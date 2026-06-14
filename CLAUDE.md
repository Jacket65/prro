# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
`prro` ("Prro beta") is the **Flutter client for the Grains World POS system** — the frontend to the Go backend that lives at `pos.grainsworld.click`. It talks to that backend's REST API (`/api/v1`) over HTTP.

- **Stack:** Flutter (Dart SDK `>=3.10.0`), `flutter_bloc` + `equatable` (state), `dio` (primary HTTP client) and `http` (admin only), `shared_preferences` (session/state persistence), `mocktail` + `bloc_test` (tests).
- **UI language:** Ukrainian (all user-facing strings, snackbars, error messages).
- **Targets:** multi-platform (android/ios/web/windows/linux/macos); CI builds the Android APK.

## Dev Commands

```bash
flutter pub get                    # install deps
flutter analyze                    # lint (flutter_lints 6.0 via analysis_options.yaml)
flutter test                       # all tests
flutter test test/login_bloc_test.dart                       # single file
flutter test --plain-name 'emits [LoginLoading, LoginSuccess'  # single test by name
flutter run                        # run on a connected device/emulator
flutter build apk --release        # what CI produces (.github/workflows/flutter_ci.yml, on push to main)
```

The app expects the **backend running on `localhost:8080`**. Seeded dev credentials (from the Go seeder): `cashier1`/`cashier123`, plus `admin`/`manager1`/`manager2`/`cashier2`. The login screen has hardcoded dev shortcut buttons for the cashier and admin flows.

## Architecture

Layered, BLoC-based. Data flows **Screen/Widget → Bloc/Cubit → Repository (interface) → Service → ApiClient → backend**. Dependencies are injected at the root in `lib/app.dart` (`MyApp`) via `MultiRepositoryProvider` + `MultiBlocProvider`; repositories are always provided and consumed **by their `I` interface type** (`context.read<ItemsRepositoryI>()`), so blocs never see concrete classes.

### Layers
- **`lib/data/api/api_client.dart`** — `ApiClient` (implements `ApiClientI`), a thin Dio wrapper. A request interceptor injects `Authorization: Bearer <auth_token>` from `SharedPreferences`, sets JSON headers, and **auto-generates an `Idempotency-Key` header on every POST** (the backend's idempotency middleware requires it). Base URL is **hardcoded** in the constructor (`http://127.0.0.1:8080/api/v1`); a commented prod URL sits beside it. 401s are only logged — there is no token refresh yet.
- **`lib/data/api/models/`** — response models built on `Equatable`. `Item` is a `sealed class` with three subtypes that drive the catalog UI: `Category`, `ProductGroup` (an abstract product owning multiple variants → opens a picker), and `Product` (a single sellable variant/SKU with `price` and a `recipe` of `RecipeItem`s). `Product.toOrderJson()` is the cart→backend order shape.
- **`lib/data/repositories/<resource>/`** — one folder per resource, each with the same trio: `<resource>_repo_i.dart` (the `XxxRepositoryI` + `XxxServiceI` interfaces, where `XxxServiceI implements XxxRepositoryI`), `<resource>_repo.dart` (concrete `XxxRepository`, mostly delegating to its service), and a barrel `<resource>_repository.dart` that re-exports both. **To add a resource, follow this exact layout.**
- **`lib/data/services/`** — concrete services hold `ApiClientI` + `SharedPreferences`, make the calls, unwrap the backend's `{ "data": ... }` envelope (see `_extractList`), and map JSON → models.
- **`lib/features/<feature>/`** — `auth`, `seller`, `admin`, `shift`, `user`. Each typically has `bloc/`, `screens/`, `widgets/`. Blocs that take events use `Bloc` (e.g. `LoginBloc`, `OrdersBloc`, `ItemsTilesBloc`); simpler ones use `Cubit` (e.g. `ShiftCubit`, `BalanceCubit`).

### Two HTTP access patterns coexist (gotcha)
- **seller / auth / shift / user** features go through the injected `ApiClientI` (Dio) + repository/service abstraction described above.
- The **admin** feature instead uses a **separate, self-contained `ApiService`** at `lib/features/admin/screens/main_screen/services/api_service.dart`, built on the `http` package with its **own base URL (`http://localhost:8080/api/v1`)** and its own token + idempotency handling. It's provided via `RepositoryProvider.value(value: api)` and called directly from admin screens (full CRUD for categories/products/variants/recipes/ingredients). These two stacks have not been unified — changing API behavior may mean editing both.

### Money & decimals from the backend (gotcha)
- The backend marshals `shopspring/decimal.Decimal` as a **JSON string** (`"45.50"`). Casting `(json['price'] ?? 0) as num` will throw at runtime. **Always** parse prices / quantities / costs / recipe quantities via `parseDouble` / `parseInt` from `lib/core/json.dart` — they accept `num`, `String`, or `null` and fall back to a default. Affects: variants, products, recipes (`ingredient_id`, `quantity`), `IngredientResponse` (`cost_per_unit`, `quantity`, `min_stock_alert`).
- Money in the payment flow is **int kopecks** anywhere we do arithmetic on it — never `double`. Helpers in `lib/core/money.dart`: `uahToKopecks`, `kopecksFromString`, `formatUah(123450) → "₴1234.50"`, `formatAmount`. The cart's `OrdersRepository.totalPrice` (`double`) is only for the live "Разом" display under the cart; **the authoritative total is the one returned in the receipt** from the (mock) server.
- The frontend `Ingredient` model only carries what the bk's `IngredientResponse` actually returns (`id`, `name`, `retail_outlet_id`, `category_id`, `unit_id`, `cost_per_unit`, `quantity`, `min_stock_alert`). The old `isSellable` / `sellPrice` fields were obsolete and have been removed — there is no "sold-directly" flag on the wire yet.

### Session & navigation
- **Session = SharedPreferences.** Keys: `auth_token`, `username`, `isLogged`, `user_role`, `user_id`, `outlet_id`, `shift_opened`. There is no in-memory session object.
- **Login** (`LoginService.login`) posts to `/auth/login`, reads the JWT from the **`Authorization` response header** (not the body), then persists token/username/role/id. Because `/auth/me` doesn't yet return an outlet, it resolves `outlet_id` by taking the **first entry of `GET /retail-outlets/`** and caching it; services read `outlet_id` from prefs to build outlet-scoped URLs.
- **Auto-login** fires on startup (`LoginBloc..add(LoginCheckAutoLogin())`); logout clears the prefs above.
- **Navigation is imperative** (`Navigator.pushReplacement`), no router package. Flow: `LoginScreen` → cashier path goes to `Shift` (open shift) → `SellerScreen`; admin button jumps straight to `MainScreen`.

### Catalog → cart business logic (the core seller flow)
- `ItemsTilesBloc` does **two-level navigation** via an internal stack: depth 0 = categories, depth 1 = products of the selected category. Variants are shown in a modal dialog off a `ProductGroup` tile, so they're never pushed onto the stack.
- `ItemsService.getProducts` is **N+1**: it fetches every product's variants, then **flattens products with exactly one variant into a directly-orderable tile, shows a `ProductGroup` picker for >1, and hides products with 0 variants** (unsellable). The N+1 is a known TODO pending a combined backend endpoint.
- `OrdersRepository` is the in-memory cart: a `List<Product>` keyed by id, add increments quantity, remove decrements/drops, `totalPrice` = Σ price·quantity. `OrdersBloc` rebuilds `OrdersUpdated(products, total)` after each mutation.
- Each cart line carries its own `recipe: List<RecipeItem>`; the cashier can override ingredients per line via `recipe_editor_dialog.dart`, which dispatches `UpdateRecipe(lineId, recipe)` and the bloc re-emits.
- **Drink options:** a variant may have option groups (`OptionGroup` → `DrinkOption`, e.g. Молоко/Сироп) fetched via `ItemsRepositoryI.getVariantOptions(variantId)` (currently served by `MockBackend.getVariantOptions`; real `GET /variants/:id/options` is a pending backend dependency). Flow (`options_picker_dialog.dart`): adding from the catalog (`startAddToCart`, used by the product tile and variant picker) does **not** prompt — it adds the drink with its **default** options applied (`_defaultSelection`: first option of each `single` group; `multi` groups start empty). The cashier edits options by **tapping the line in the order area** (`ListItem._onTap` → `OptionsPickerDialog.show`: single→radio, multi→checkbox + per-portion stepper, required-group validation), which dispatches `UpdateOptions(lineId, options)`; if the variant has no option groups the tap falls back to the recipe editor. Coffee drinks (category "Кава") also have **bean selection**: `ItemsRepositoryI.getVariantBeans(variantId)` returns `BeanGroup`s (Купаж/Ароматизовані/Арабіка/Без кофеїну, served by `MockBackend.getVariantBeans`); the dialog shows them as expandable groups with a single bean choice across all groups, and a default bean (`_defaultBean`) is applied on catalog add. Picked options ride on `Product.selectedOptions`, the bean on `Product.selectedBean`; cart lines are keyed by `Product.lineId` (`id` + sorted options + bean) so the same drink with different options/bean is a separate line, and changing a line can merge it into an identical existing line (`OrdersRepository.updateOptions`, which takes the bean too). The single dialog (`OptionsPickerDialog`) edits both options and bean; `openLineEditor` decides between it and the recipe editor. Live "Разом" uses `Product.effectiveUnitPrice` (base + Σ surcharge·portions); the authoritative total (incl. options) comes from `MockBackend.placeOrder`. NOTE: for the options to be visible offline, `lib/app.dart` currently points the seller catalog at `MockItemsService` — swap back to `ItemsService` once the backend serves options.

### Payment flow
- All wired in `lib/features/seller/widgets/check/check_pay_button.dart`. The "ОПЛАТА" button is disabled when the cart is empty and shows the running total via `formatUah(kopecks)`.
- The dialog generates **one `idempotencyKey` in `initState`** (not per click) — a double-tap on "Оплатити" replays the same key and the mock returns the cached receipt instead of creating a second order.
- Two methods via `SegmentedButton`: **Готівка** (tendered must be ≥ total → change = tendered − total; "Оплатити" disabled otherwise) and **Картка** (amount fixed to total exactly, no tendered input, no change).
- States are driven by `OrdersBloc`: `OrdersLoading` shows a spinner inside the button, `OrdersError` shows a red banner, `OrdersPaymentSuccess(receipt)` swaps the dialog body to a native Flutter receipt card built from the receipt's structured fields (`storeName`, `cashierName`, `lines`, `totalKopecks`, `tenderedKopecks`, `changeKopecks`, `issuedAt`). There is no HTML — the receipt is rendered with `Table` widgets in monospace.
- `AcknowledgePayment` returns the bloc to the live cart state; `BalanceCubit.fetchBalance()` is fired alongside to refresh the cash drawer display.
- A small "Симулювати помилку сервера" switch in the dialog flips `MockBackend.simulateError` so error states can be exercised without touching code.

## Backend endpoints not implemented yet → client stubs
Several backend routes are still stubs on the server, so their client counterparts are **deliberately faked** (don't treat them as broken):
- **`ShiftService.openShift`/`closeShift`** return success without any network call; shift state is only persisted in `shared_preferences` (`shift_opened`).
- **Orders** are placed against an in-process `MockBackend` (`lib/data/mock/mock_backend.dart`) instead of `POST /orders` (which the server doesn't expose yet). `OrdersRepository.placeOrder({method, tenderedKopecks, idempotencyKey})` calls `MockBackend.placeOrder()` and returns an `OrderReceipt` containing the authoritative total/change and a snapshot of line items. The mock looks up variant prices it served itself, validates payment per the rules above, dedupes by `idempotencyKey`, and ~300 ms latency is simulated. `MockBackend.simulateError = true` makes the next call fail. (`MockItemsService` next to it can also swap out the real catalog for an offline coffee-shop dataset — currently unwired, kept as a fallback.)
- **Measure units** are a static list in `ApiService` matching the seeder, pending `GET /api/v1/measure-units`.

## Conventions
- Interfaces are suffixed `I` (`ApiClientI`, `ItemsRepositoryI`, `ShiftServiceI`). Each resource exposes a barrel file; import the barrel, not the impl.
- Logging uses `dart:developer`'s `log()`. The `talker` / `talker_bloc_logger` deps are present but the `Bloc.observer` wiring in `main.dart` is currently commented out.
- Models extend `Equatable`; provide `props` for value equality (bloc state comparisons rely on it).