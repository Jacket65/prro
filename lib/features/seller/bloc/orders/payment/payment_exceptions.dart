/// App-level payment failure surfaced to the UI layer.
///
/// Translates every method-specific failure (e.g. NFC terminal errors) into a
/// single boundary type so `OrdersBloc` stays payment-implementation agnostic.
final class PaymentException implements Exception {
  const PaymentException(this.message);
  final String message;

  @override
  String toString() => 'PaymentException: $message';
}

/// App-level cancellation raised when the cashier (or customer) cancels the
/// in-flight payment.
///
/// Deliberately **not** a subtype of [PaymentException] so the bloc's
/// `on PaymentException` clause can never accidentally swallow a cancellation —
/// cancellations return to the form, failures show an error.
final class PaymentCancelledException implements Exception {
  const PaymentCancelledException();
}
