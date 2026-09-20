import 'package:prro/data/api/models/models.dart';

/// Strategy for handling a single [PaymentMethod].
///
/// The order-first sequence is: `pay` → `OrdersRepositoryI.placeOrder` →
/// [afterOrderCreated]. Cash implements both hooks trivially (the backend
/// finalizes the charge inside `placeOrder`); the terminal handler charges the
/// external POS terminal in [afterOrderCreated] — only after a server-side
/// order record exists — and then confirms the pending order.
abstract interface class PaymentMethodHandler {
  PaymentMethod get method;

  /// Performs the method-specific step BEFORE the order is placed.
  ///
  /// A no-op for both cash and terminal today: cash is charged by the backend
  /// inside `placeOrder`, and the terminal charge must not start before the
  /// order record exists (see [afterOrderCreated]). May throw a
  /// `PaymentException` / `PaymentCancelledException` to abort the sale before
  /// any order is created.
  Future<void> pay(PaymentRequest request);

  /// Finalizes the payment AFTER `placeOrder` succeeded, returning the receipt
  /// the UI should show.
  ///
  /// Cash returns the receipt unchanged. The terminal handler launches the
  /// terminal charge here and confirms the resulting `pending` order on
  /// success. Throws only `PaymentException` / `PaymentCancelledException`.
  Future<OrderReceipt> afterOrderCreated(
    OrderReceipt order,
    PaymentRequest request,
  );

  /// Aborts an in-flight payment step if the method supports it.
  ///
  /// No-op for cash (no cancellable external op); real behaviour lives in the
  /// terminal handler.
  void cancel();
}

/// Input to a [PaymentMethodHandler.pay].
///
/// Only the charge amount (derived by the use case from the live cart total),
/// the tendered amount, and the currency are carried here. The payment method
/// is implied by the handler that receives it, so no `method` field is needed.
final class PaymentRequest {
  const PaymentRequest({
    required this.amountKopecks,
    required this.tenderedKopecks,
    required this.currency,
  });

  /// Amount to charge the customer (in kopecks). For the terminal this is sent
  /// to the POS terminal; for cash it is informational only (the backend
  /// computes the real total inside `placeOrder`).
  final int amountKopecks;

  /// Amount the customer tendered (in kopecks). For cash this is what was
  /// handed over; for the terminal it equals the charge amount.
  final int tenderedKopecks;

  /// ISO currency code (e.g. 'UAH').
  final String currency;
}
