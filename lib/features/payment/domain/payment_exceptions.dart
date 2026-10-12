/// App-level payment failure surfaced to the UI layer.
///
/// Translates every method-specific failure (e.g. terminal launch errors,
/// repository/network errors, deep-link failures) into a single boundary type
/// so `OrdersBloc` stays payment-implementation agnostic. Cancellation is a
/// separate type (see [PaymentCancelledException]) so a cancellation can never
/// be swallowed by the `on PaymentException` clause.
enum PaymentFailureReason {
  /// Terminal app could not be launched.
  terminalUnavailable,

  /// Terminal declined / reported a terminal error.
  terminalDeclined,

  /// Waiting for the terminal callback timed out.
  terminalTimeout,

  /// The deep-link callback was malformed, untrusted, or for another session.
  invalidCallback,

  /// Backend verification of a (seemingly successful) payment failed.
  verificationFailed,

  /// A repository/network error occurred while preparing or confirming payment.
  network,

  /// The backend does not expose the terminal payment endpoints, so a card
  /// payment cannot be attempted at all (the route is absent/unimplemented).
  ///
  /// Distinct from [terminalUnavailable]: the terminal *app* may be installed
  /// and healthy while the backend cannot start or verify a charge, so the
  /// cashier must be told the method is unavailable instead of seeing a
  /// generic server error.
  terminalEndpointUnavailable,

  /// A second payment was started while one is already active.
  alreadyInProgress,

  /// Anything not covered by the categories above.
  unknown,
}

final class PaymentException implements Exception {
  const PaymentException(
    this.message, {
    this.reason = PaymentFailureReason.unknown,
    this.cause,
    this.stackTrace,
  });

  /// Human-readable, UI-safe message. Kept required so existing call sites and
  /// the error state that consumes it keep working without null-churn.
  final String message;

  /// Machine-readable category. Preferred over string-matching the message when
  /// the UI/analytics need to branch on the failure type.
  final PaymentFailureReason reason;

  /// Original exception that triggered this failure (may be null). Preserved so
  /// the boundary can log the real cause without leaking it to the cashier.
  final Object? cause;

  /// Original stack trace. Preserved for diagnostics.
  final StackTrace? stackTrace;

  @override
  String toString() => 'PaymentException(${reason.name}): $message';
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
