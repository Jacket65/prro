import 'package:prro/data/api/models/models.dart';

/// Strategy for handling a single [PaymentMethod].
///
/// Each concrete handler knows how to perform (or skip) the payment-specific
/// step before the order is placed via `OrdersRepositoryI.placeOrder`. Cash and
/// card handlers are no-ops because the backend performs the actual charge
/// inside `placeOrder`; only the NFC handler talks to an external terminal.
abstract interface class PaymentMethodHandler {
  PaymentMethod get method;

  /// Performs the method-specific payment step.
  ///
  /// For NFC this launches the terminal and resolves once the customer has paid
  /// (or throws a `PaymentException` / `PaymentCancelledException`). For cash
  /// and card it does nothing — the charge happens inside `placeOrder`.
  Future<void> pay(PaymentRequest request);

  /// Aborts an in-flight [pay] if the method supports it.
  ///
  /// No-op for cash/card (no cancellable external op); real behaviour lives in
  /// the NFC handler.
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

  /// Amount to charge the customer (in kopecks). For NFC this is sent to the
  /// terminal; for cash/card it is informational only (the backend computes the
  /// real total inside `placeOrder`).
  final int amountKopecks;

  /// Amount the customer tendered (in kopecks). For cash this is what was
  /// handed over; for card/nfc it equals the charge amount.
  final int tenderedKopecks;

  /// ISO currency code (e.g. 'UAH').
  final String currency;
}
