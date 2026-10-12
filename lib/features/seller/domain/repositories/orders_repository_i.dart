import 'package:decimal/decimal.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/order.dart';

abstract interface class OrdersRepositoryI {
  List<Product> get products;
  double get totalPrice;

  /// Adds [product] (or bumps an identical line by one unit step).
  void addProduct(Product product);

  /// Drops one unit step from the matching line (removing it at the minimum).
  void removeProduct(Product product);

  void deleteProductLine(Product product);

  /// Drops the whole cart. Used by the seller UI (cart emptied, failed order)
  /// and must also be safe to call when the session is being torn down.
  void clearProducts();

  /// Drops the cart **and any per-session residue** it carries, e.g. an order
  /// placed against a shift that is no longer this seller's.
  ///
  /// The repository is a process-wide singleton, so without this the previous
  /// cashier's lines survive into the next login (see F8). Called at the start
  /// of every login and on every session end (logout, session expiry, the
  /// admin re-login) — the two moments the *next* seller must not inherit
  /// anything.
  void resetForNewSession();

  /// Replaces the selected options, bean and (if given) [quantity] of the cart
  /// line identified by [lineId]. Changing options/bean changes the line
  /// identity; if that matches another existing line the two are merged
  /// (quantities summed).
  void updateOptions(
    String lineId,
    List<SelectedOption> options, {
    Bean? bean,
    Decimal? quantity,
  });

  /// Sends the current cart to the backend (`POST /retail-outlets/{id}/orders`).
  /// Prices and totals are computed server-side; the receipt is authoritative.
  ///
  /// Throws [ShiftClosedException] when the backend answers 404 because the
  /// seller's shift is no longer open (it can be closed from another device
  /// while the screen is still up).
  ///
  /// Re-calling with the same [idempotencyKey] is safe and returns the same
  /// receipt (no duplicate order is created).
  Future<OrderReceipt> placeOrder({
    required PaymentMethod method,
    required int tenderedKopecks,
    required String idempotencyKey,
  });

  /// Confirms a pending (card/terminal) order: `POST /orders/{id}/confirm`.
  ///
  /// The backend moves a `type=card` order to `pending` without any cash/stock
  /// movement; this call completes it (and only then does the backend move
  /// stock). Re-calling on an already-completed order yields 409 — callers
  /// should treat that as "already done" at a higher layer if it matters.
  Future<OrderReceipt> confirmOrder(int orderId);
}

/// The seller's shift is closed, so an order cannot be placed right now.
///
/// A domain fact rather than a message: the repository reports *what* happened
/// and the payment boundary (`PayOrderUseCase`) owns the wording, which is the
/// only place whose translation the UI actually sees. A Ukrainian string thrown
/// from here would be swallowed by that boundary and never rendered.
class ShiftClosedException implements Exception {
  const ShiftClosedException();
}
