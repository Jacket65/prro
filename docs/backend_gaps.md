# Backend gaps

This document is the single place that lists what the Go backend does **not**
(yet) do, what the Flutter client does about it, and where every accommodation
lives. It exists so a future session never has to re-derive these facts from
code archaeology or from git-ignored plan files.

## How to read this

The client is written against the backend it should have, not the backend it
has. Every path, interface, implementation and mock for a missing or stubbed
route **stays in the codebase** — the user audits backend gaps separately and
adds what is needed. Removing a call because the server cannot answer it today
would only mean writing it back later.

Evidence lines below are `file:line` references from the contract audit
(`.kilo/plans/1790847706182-go-backend-contract-alignment.md`, itself derived
from `prod_api_backend_real.txt`) and from the current client code.

## Gap table (B1–B10)

| # | Backend fact | Evidence |
|---|---|---|
| B1 | `PUT /api/v1/variants/:id/recipe` is a no-op returning `200 {"data":null}` — the whole recipe body is commented out | `routes.go:115`, `internal/service/services/variant.go:180` |
| B2 | `PATCH`/`DELETE /retail-outlets/:outlet_id/users/:user_id` always 400: `dto.UserUri.ID` is tagged `uri:"id"` but the route param is `:user_id`, so binding fails and `code`/`message` are **both empty strings** | `internal/dto/user.go:34-37`, `routes.go:41-42` |
| B3 | `POST /retail-outlets/:id/shift/open` binds no body at all, yet the app sends `{"cash_start":…}`; `dto.ShiftResponse` has no `cash_start`, so the opening float is never persisted or returned (it exists only implicitly in the cash ledger) | `handlers_shift.go:21-40`, `internal/dto/shift.go:22-31` |
| B4 | Swagger documents the bare DTO instead of `server.Envelope`, so `/swagger` cannot be used to generate a client | every `@Success` in `internal/app/server/*.go` vs `response.go:30` |
| B5 | `error.code` can be `""` — clients must not assume a non-empty code | the B2 path through `response.go:70-126` |
| B6 | `dto.UserResponse.outlet_id` has `omitempty` but is never set by login or refresh | `handlers_auth.go:65-72`, `:112-119` |
| B7 | `dto.UserCreateRequest.role` validates to `manager`/`cashier` **only** — an `admin` account can only come from the seeder | `internal/validation/validation.go` |
| B8 | `GET /shifts/:id/orders` returns `status = 'completed'` only, so pending card orders never appear in history | `internal/service/services/order.go` |
| B9 | No CORS middleware anywhere in the backend. Flutter **web** builds fail preflight; mobile is unaffected and CI builds the Android APK | repo-wide search: zero matches for `cors`/`Access-Control` |
| B10 | `meta.request_id` is emitted only when `gin.Mode() != release` — clients must treat it as optional | `response.go:44-46` |

## Client-side accommodations

### Terminal payments: the routes do not exist (not in B1–B10)

`POST /retail-outlets/{id}/payments/create` and `.../payments/check` are
declared in the payment contract but answer 404 (absent route) or 501
(explicitly unimplemented) — verified by
`test/features/payment/data/repositories/payment_repository_impl_test.dart`.
The client keeps the whole feature (interface, service, handler, dialog
segment) and reports the gap honestly:

- `PaymentRepositoryImpl` maps 404/501 to
  `TerminalPaymentEndpointUnavailableException`
  (`lib/features/payment/data/repositories/payment_repository_impl.dart`).
- `TerminalPaymentHandler` translates it to a `PaymentException` with reason
  `terminalEndpointUnavailable` and the wording "Оберіть готівку."
  (`lib/features/seller/domain/payment/handlers/terminal_payment_handler.dart`).
- The payment dialog shows that message in its error banner and stays on the
  form (`payment_dialog_views_test.dart` pins the outcome).
- Once the backend implements the two routes this stops firing with no
  client change.

### B1 recipe stub: reads are authoritative, writes fail honestly

`replaceRecipe` is sent, then the recipe is re-read from the server, and a
`{"data":null}` answer is reported as "Сервер не зберіг рецепт." instead of a
success (`lib/features/admin/data/repositories/admin_catalog_repository_impl.dart`,
plus `variant_detail_cubit.dart` for the re-read). The admin can never be shown
a phantom recipe that reverts on the next reload.

### B3 `cash_start`: sent, never stored

`openShift` sends `{"cash_start": "0.00"}`
(`lib/features/shift/data/repositories/shift_repository_impl.dart`, the open
call under the endpoint header) because that is the real contract; the backend
ignores it. The client shows no
"opening float" anywhere and derives the shift list from the server, so the
missing field is invisible rather than fabricated. The field must keep being
sent: once the backend binds it, no client change is needed.

### B8 pending card orders never appear in history

A terminal order that is placed but not confirmed would be unreachable from
the app (history lists only completed orders). The client records it locally
before the charge (`PayOrderUseCase`) and offers a resume banner
(`PendingOrderBanner`, mounted in the check column and the open-shift gate)
that finishes the order through `FinishPendingOrderUseCase`.

### B2/B5 empty `code`/`message` on a binding failure

`ApiException.fromDio` unwraps `error.code` through a message map and falls
back to the server's raw `message`, then to a generic one — an empty code and
an empty message cannot crash the mapping
(`lib/core/network/api_exception.dart`).

### B6 `outlet_id` not echoed by login

The client does not read the outlet id from the login/refresh response; it
keeps the one written at login (`auth_repository.dart`) in SharedPreferences
and reads it through `core/data/outlet_scope.dart` (`requireOutletId` for
scoped endpoints, `maybeOutletId` where "no outlet" means "empty result").

### B4/B7/B9/B10: audit notes with no client impact

- B4 (Swagger shows bare DTOs): client decoding is hand-written against the
  real envelope, so this costs documentation only.
- B7 (roles): the admin UI does not create `admin` accounts.
- B9 (no CORS): mobile only. Revisit before any Flutter web build.
- B10 (`meta.request_id` in debug only): the client ignores `meta` entirely.

## Related

- Known gaps section in `CLAUDE.md` (architecture-level summary).
- `lib/features/shift/data/repositories/shift_repository_impl.dart` header —
  the shift routes and the `cash_start` note live next to the calls.
- `lib/features/payment/data/repositories/payment_repository_impl.dart` header —
  the terminal routes and their signed-JWT design.
