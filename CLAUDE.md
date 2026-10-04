# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
`prro` ("Prro beta") is the **Flutter client for the Grains World POS system** — the frontend to the Go backend deployed at `pos.coffeebeans.space` (dev host `pos.coffeebeans.space.test`). It talks to that backend's REST API (`/api/v1`) over HTTP.

- **Stack:** Flutter (Dart SDK `>=3.12.0`, CI on Flutter `3.44.6`), `flutter_bloc` + `equatable` (state), `dio` (the only HTTP client), `injectable` + `get_it` (DI), `auto_route` (navigation), `freezed` + `json_serializable` (admin/payment wire DTOs), `shared_preferences` (session persistence), `mocktail` + `bloc_test` (tests).
- **UI language:** Ukrainian (all user-facing strings, snackbars, error messages).
- **Targets:** multi-platform (android/ios/web/windows/linux/macos); CI builds the Android APK.

## Dev Commands

```bash
flutter pub get                    # install deps
dart run build_runner build   # regenerate di.config.dart, app_router.gr.dart, *.g.dart, *.freezed.dart
./tool/check_boundaries.sh         # layer-boundary check (also a CI step, before flutter analyze)
flutter analyze                    # lint (very_good_analysis 11 via analysis_options.yaml)
flutter test                       # all tests
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart   # single file
flutter test --plain-name 'emits [AuthLoading'                          # single test by name
dart fix --apply                   # resolve fixable lints (project convention: run it, then read the diff)
flutter run                        # run on a connected device/emulator
flutter build apk --release --dart-define=BACKEND_TYPE=real --dart-define=API_BASE_URL=...  # what CI produces
```

**After any move or annotation change, run `build_runner` *before* `flutter analyze`** — stale generated paths produce misleading errors. Generated files are never hand-edited: `git mv` the `part` source, delete its generated output, and let `build_runner` rewrite it.

The backend base URL comes from `--dart-define=API_BASE_URL` via `core/config/env.dart`; `BACKEND_TYPE=mock` swaps every `@Environment('mock')` binding. Seeded dev credentials: `cashier1`/`cashier123`, plus `admin`/`manager1`/`manager2`/`cashier2`.

## Architecture

**Feature-first.** Each feature owns `domain/` (contracts + entities), `data/` (implementations + wire DTOs) and `presentation/` (blocs, cubits, screens, widgets). `core/` holds anything genuinely shared plus app infrastructure. Dependencies point inward, and `tool/check_boundaries.sh` enforces that mechanically.

Data flows **Screen/Widget → Bloc/Cubit → `XxxRepositoryI` (domain) → `data/` implementation → `ApiClientI` → backend**. Consumers only ever see the `I` interface.

```
lib/
├── main.dart · app.dart                     composition roots
├── core/
│   ├── config/       backend_config · env · payment_config
│   ├── di/           di · app_module · di.config.dart*            (*generated)
│   ├── router/       app_router · app_router.gr.dart*             (*generated)
│   ├── domain/       shared entities + repositories/order_history_repository_i
│   ├── data/         shared implementations (order-history only) + outlet_scope
│   ├── network/      api_client · api_client_i · api_exception · unwrap
│   ├── security/     token_storage_i · secure_token_storage · in_memory_token_storage
│   ├── mock/         mock_backend · mock_api_client · order_request_dto
│   ├── presentation/ order_history (cubit + view shared by seller and admin)
│   ├── theme/ · utils/ (breakpoints · json · money · uuid)
└── features/
    ├── auth/    domain/{entities,repositories} · data/repositories · presentation/{bloc,screens}
    ├── shift/   domain/{entities,repositories} · data/{repositories,mock} · presentation/{cubit,widgets}
    ├── seller/  domain/{entities,repositories,payment,usecases} · data/{repositories,mock} · presentation/{bloc,screens,widgets}
    ├── admin/   domain/repositories · data/{models,repositories,mock} · presentation/{cubit,screens,widgets}
    └── payment/ domain/{payment_exceptions,repositories} · data/{models,repositories,services,mock}
```

### Layer rules (enforced by `tool/check_boundaries.sh`)

| # | Rule |
|---|-------|
| R1 | `domain/` may not import `presentation/`, `core/di`, `core/router`, `package:flutter`, or another feature's `data/` |
| R2 | `data/` may not import `presentation/` or another feature's anything |
| R3 | `presentation/` may not import another feature's `presentation/` or `data/` |
| R4 | Nothing may import `package:prro/data/` — the old global layer is gone |
| R5 | `core/` may not reach into `features/`, except `core/mock` and the composition roots `core/di` + `core/router` |
| R6 | `domain/` is framework-free: no `package:dio` / `http` / `freezed` / `get_it` |

The rules apply to `lib/` only — a test may import whatever the code under test imports. R4 also covers `test/`.

**Documented exceptions** (all encoded in the script, all still enforced in the other direction):
- `seller/presentation` → `auth/presentation/bloc` and `shift/presentation/{cubit,widgets}` — the cashier name / logout trigger and the open/close-shift flow.
- `core/mock` → `features/*/data/models` and `core/domain` — `MockBackend` seeds admin DTOs and returns shared entities.
- `<f>/domain` → its own `<f>/data/models` — a contract names its feature's wire DTOs (see DTOs below).
- `seller/domain/payment/handlers/terminal_payment_handler.dart` → `payment/data/models/payment_request.dart`.
- `seller/domain/repositories/items_repository_i.dart` → `package:dio` for the `CancelToken` on `searchProducts`.

### How to add a feature
1. `lib/features/<f>/` with `domain/`, `data/`, `presentation/`.
2. Contracts + entities in `domain/`: `domain/entities/*.dart`, `domain/repositories/<r>_i.dart` (interface suffixed `I`).
3. Implementations in `data/repositories/<r>_impl.dart` with `@Environment('prod') @Singleton(as: <R>I)` holding `ApiClientI`; the mock in `data/mock/<r>_mock.dart` with `@Environment('mock')`. Both must be annotated or mock mode silently resolves to prod.
4. Register nothing by hand — `injectable` discovers the annotations and `build_runner` regenerates `di.config.dart`.
5. UI in `presentation/{bloc|cubit,screens,widgets}/`.
6. Tests mirror `lib/` exactly under `test/`.

### How to add a resource
- **Consumed by more than one feature → `core/`.** Consumed by exactly one → that feature's `data/`. (`Bean` lives in `core/domain/bean.dart` because the shared `Product` entity references it; `Ingredient` is seller-only.)
- **One contract, not two.** A repository interface plus a service interface with the same members behind a pure pass-through is the anti-pattern this codebase has now removed everywhere: `ItemsServiceI`/`BalanceServiceI`, then `ShiftServiceI`, `OrderHistoryServiceI` and `PaymentServiceI`. No feature has a `services/` twin of a repository any more — the only remaining `features/payment/data/services/` are `deep_link_service`, `terminal_launcher` and `terminal_payment_service`, which hold real logic. Put the contract in `domain/repositories/` and let the `data/` class implement it directly.
- **Entity vs DTO:** domain entities keep their inline `fromJson` factory. Only the freezed/json_serializable wire models (`admin/data/models`, `payment/data/models`) get generated `fromJson`/`toJson` — don't duplicate those into domain.
- Unwrap the backend's `{ "data": ... }` envelope with the shared helpers, never by hand: `unwrapList` / `unwrapObject` in `core/network/unwrap.dart`, and `unwrapPayload` / `unwrapData` in `core/utils/json.dart` (`core/domain` uses the latter so it need not reach into `core/network`). `unwrapPayload` is type-directed and falls back to the envelope; `unwrapData` is presence-based and returns `null` for `{"data": null}` — that is how the stub recipe response is detected.

### HTTP access
One stack: everything goes through the injected `ApiClientI` (Dio). A request interceptor injects `Authorization: Bearer <token>` from `TokenStorageI` and sets JSON headers. `Idempotency-Key` is **not** generated by the client: `ApiClient._mergeHeaders` only forwards a caller-supplied key, and the backend rejects a mutating POST without one (400 `bad_request`). Every mutating POST in the app therefore generates a `uuidV4()` once per dialog/screen action and passes it explicitly. `ApiClient` also collapses concurrent 401s into a single `onUnauthorized` event so the app tears the session down once. `@Environment('prod')` binds `ApiClient`, `@Environment('mock')` binds `MockApiClient` over the app-wide `MockBackend` singleton.

### Money & decimals from the backend (gotcha)
- The backend marshals `shopspring/decimal.Decimal` as a **JSON string** (`"45.50"`). Casting `(json['price'] ?? 0) as num` throws at runtime. Always parse via `parseDouble` / `parseInt` from `core/utils/json.dart` — they accept `num`, `String` or `null` and fall back to a default.
- Money is **`int` kopecks** anywhere we do arithmetic — never `double`. Helpers in `core/utils/money.dart`: `uahToKopecks`, `kopecksFromString`, `formatUah(123450) → "₴1234.50"`. `OrdersRepository.totalPrice` is a `double` used **only** for the live "Разом" display; the authoritative total is the one in the `OrderReceipt` the server returns.
- Known inconsistency, deliberately not "fixed": `Category.fromJson` uses `json['id'] as int` while `Product.fromJson` uses `parseInt`, and `Product`/`ProductGroup`/`Category` ids are `String`/`int` respectively.

### Session & navigation
- **Session = SharedPreferences + `TokenStorageI`.** Token keys (`auth_token`, `refresh_token`) live behind `SecureTokenStorage`/`InMemoryTokenStorage`; the session metadata keys are `username`, `user_role`, `user_id`, `outlet_id`. There is no `isLogged` / `shift_opened` flag — `AuthBloc`'s state is derived from whether a valid token is present.
- **Login** (`AuthRepositoryImpl.login`) posts to `/auth/login`, reads the JWT from the **`Authorization` response header**, then persists token/username/role/id. `dto.UserResponse` has an `outlet_id` field, but the login handler leaves it empty, so the repository falls back to the first entry of `GET /retail-outlets/` and caches it; reading the login body first keeps a future backend fix authoritative. Services read `outlet_id` from prefs to build outlet-scoped URLs.
- `AuthBloc` events: `AuthStarted` (restore), `AuthLoginRequested`, `AuthAdminLoginRequested` (no credentials + admin/manager role), `AuthLogoutRequested`, `AuthSessionExpired(failedToken)` (a 401 whose failed token matches the current one, so a stale 401 can't log out a fresh session).
- **Navigation is declarative** (`auto_route`, `core/router/app_router.dart`). `AuthGuard` redirects to `LoginRoute` when there is no authenticated bloc. Flow: `LoginScreen` → cashier path opens a shift → `SellerScreen`; "Я адміністратор" goes to `AdminShell` (tabbed outlets/tellers/items).

### Catalog → cart (the core seller flow)
- `ItemsTilesBloc` does **two-level navigation** via an internal stack: depth 0 = categories, depth 1 = products of the selected category. Variants open in a modal dialog off a `ProductGroup` tile, so they're never pushed.
- `ItemsRepository.getProducts` flattens the response: one variant → a directly-orderable tile, more than one → a `ProductGroup` picker, zero → hidden (unsellable). Variants arrive inline; `_optionsCache` + `_optionsInFlight` de-duplicate the options/beans request per variant.
- `OrdersRepository` is the in-memory cart: a `List<Product>`, add increments quantity, remove decrements/drops, `totalPrice` = Σ price·quantity. `OrdersBloc` re-emits `OrdersUpdated` after each mutation.
- **Drink options:** a variant has option groups (`OptionGroup` → `DrinkOption`). Adding from the catalog applies each `single` group's default (`_defaultSelection`); the cashier edits by tapping the line in the order area (`OptionsPickerDialog`: single→radio, multi→checkbox + per-portion stepper, required-group validation). Coffee drinks also support **bean selection** via `getVariantBeans` → `BeanGroup`s with a single bean choice across groups (`_defaultBean` applied on catalog add). Picked options ride on `Product.selectedOptions`, the bean on `Product.selectedBean`; cart lines are keyed by `Product.lineId` (id + sorted options + bean), so the same drink with a different option/bean is a separate line, and editing a line can merge it into an identical existing one.
- Live "Разом" uses `Product.effectiveUnitPrice` (base + Σ surcharge·portions); the authoritative total including options comes from the server receipt.

### Payment flow
- `PaymentMethodHandler` is a strategy (`features/seller/domain/payment/`). The order-first sequence is `pay` → `OrdersRepositoryI.placeOrder` → `afterOrderCreated`. `CashPaymentHandler` is trivial (the backend finalizes inside `placeOrder`); `TerminalPaymentHandler` charges the external POS terminal in `afterOrderCreated` — only after a server-side order record exists — and then confirms the pending order. **Money never moves before the order record exists**, and confirm is re-call-safe.
- `features/payment/` owns the capability, not a screen: `TerminalPaymentServiceI` (the contract), its `data/` implementation, `terminal_launcher`, `deep_link_service`, and the boundary exception types.
- `TerminalPaymentService` mints a fresh correlation id per session, subscribes to the deep link *before* launching the terminal, validates the callback (scheme/host, `orderId` must equal the session id, `status` must be in the contract, `transaction_id` must match `^[A-Za-z0-9_-]{6,64}$`), arms the timeout only after a successful launch, and tears everything down in `finally`. **Backend `verifyPayment` is the single source of truth** — success is never taken from the callback status.
- `TerminalPaymentHandler` is the exception boundary: `TerminalPaymentException` subclasses become `PaymentException` (preserving `PaymentFailureReason`, cause and stack trace) and `TerminalPaymentCancelledException` becomes the app-level `PaymentCancelledException`. Cancellation is deliberately **not** a `PaymentException` subtype so the bloc's `on PaymentException` clause can never swallow it.
- The payment dialog generates **one `idempotencyKey` in `initState`**, so a double-tap replays the same key instead of creating a second order. "Симулювати помилку сервера" flips `MockBackend.simulateError`.

## Known gaps
- **Terminal charge idempotency.** If the external terminal charge succeeds but `verifyPayment` fails, the flow is not retried idempotently. `placeOrder` idempotency covers only order creation, so this needs server-side correlation.
- **`getIngredients()` was removed** with the recipe editor; `Ingredient` went with it. Admin recipe editing uses `RecipeIngredient`/`AdminIngredient` from `admin/data/models/catalog.dart` instead.

### Backend contract

Ground truth is the **Go source**, not the Swagger dump: `prod_api_backend_real.txt` / `/swagger` documents bare DTOs because every `@Success` annotation omits the `server.Envelope` that `internal/app/server/response.go` actually wraps around. Re-verify any contract change against the Go repo.

Every non-204 response is `{"data": …, "error": {"code", "message"}, "meta": {"request_id"}}`; `meta.request_id` is emitted only when `gin.Mode() != release`, so treat it as optional. `error.code` is one of `not_found`, `conflict`, `access_denied`, `bad_request`, `validation_error`, `unauthorized` (bad login — do **not** refresh), `token_error` (expired/invalid JWT — refresh), `internal_error` — and it may be `""`. `ApiException` maps all eight to Ukrainian and falls back to the server's own message only for unmapped codes; `code`/`statusCode` are preserved because the auth and order flows branch on them. The access token arrives in the **`Authorization` response header** (15 min TTL; refresh rotates). Roles are `admin` / `manager` / `cashier` — there is no `seller` role. Pages are `{items, page, has_next, next_page?}`, size 20, no total. `Idempotency-Key` is mandatory on mutating POSTs.

Known backend defects — Go-side fixes, deliberately **not** worked around in Flutter:

| # | Defect |
|---|-------|
| B1 | `PUT /variants/:id/recipe` is a no-op returning `200 {"data":null}` (handler body commented out). `AdminCatalogRepositoryImpl.replaceRecipe` treats a null payload as a failure, so the recipe editor rolls back and reports "не вдалося зберегти". |
| B2 | `PATCH`/`DELETE /retail-outlets/:outlet_id/users/:user_id` always 400: `dto.UserUri.ID` is tagged `uri:"id"` but the route param is `:user_id`. The bind failure returns **empty** `code` *and* `message`. |
| B3 | `POST /retail-outlets/:id/shift/open` binds no body, so the app's `{"cash_start":…}` is discarded and `dto.ShiftResponse` has no `cash_start` — the opening float survives only in the cash ledger, so `cashStart` always reads `0.00`. |
| B4 | Swagger documents the bare DTO instead of `server.Envelope`, so `/swagger` cannot be used to generate a client. |
| B5 | `error.code` can be `""` — clients must not assume a non-empty code. |
| B6 | `dto.UserResponse.outlet_id` has `omitempty` but is never populated by login or refresh. |
| B7 | `dto.UserCreateRequest.role` validates to `manager`/`cashier` only — an `admin` account can only come from the seeder. |
| B8 | `GET /shifts/:id/orders` returns `status = 'completed'` only, so pending card orders never appear in history. |
| B9 | No CORS middleware anywhere in the backend — Flutter **web** builds fail preflight. Mobile is unaffected and CI builds the Android APK. |
| B10 | `meta.request_id` is emitted only outside release mode. |

Routes the app already calls that the backend does not serve yet — left wired, visible and un-gated on purpose, failing with a 404:
- `POST /retail-outlets/{id}/payments/create` and `/payments/check` (`features/payment/data/repositories/payment_repository_impl.dart`, reached through `TerminalPaymentService` from the "Термінал" segment of the payment dialog).
- `PATCH /variants/{id}` and `DELETE /variants/{id}` (`AdminCatalogRepositoryImpl`) — contract only, no UI caller today. (`updateProduct`/`deleteProduct` hit routes that *do* exist and are correct, just unreachable.)
- User create/update/delete and outlet create/update/delete — the backend serves them, the app calls none of them, and no contract declares them (`AuthRepositoryI` is login/restore/logout/currentUser only). Add a contract when the UI needs them.

## Conventions
- Interfaces are suffixed `I` (`ApiClientI`, `ItemsRepositoryI`, `OrderHistoryRepositoryI`).
- **Import explicit paths, not barrels.** The global barrels (`data/api/models/models.dart`, `data/repositories/repositories.dart`, `data/services/services.dart`, and the per-feature `admin.dart` / `auth.dart` / `bloc.dart` / `widgets.dart`) were all deleted. The one deliberate survivor is `features/admin/data/models/admin_models.dart`, which the app-wide `MockBackend` uses to reach the admin DTOs.
- `analysis_options.yaml` uses `very_good_analysis` 11 with `unused_import: error` and strict casts/inference/raw-types. No analyzer-coupled lint plugin is installed: `custom_lint`/`module_boundary` pin the `analyzer` package, which already conflicts with the freezed/auto_route_generator split (see `pubspec.yaml`), so the boundary check is a plain `rg` script instead.
- Models extend `Equatable` and provide `props`; bloc state comparisons rely on value equality.
- Logging uses `dart:developer`'s `log()`; the payment flow uses the injected `Talker`.
