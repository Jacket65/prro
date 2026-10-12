import 'package:prro/features/payment/data/models/payment_request.dart';
import 'package:prro/features/payment/data/models/payment_result.dart';
import 'package:prro/features/payment/domain/payment_exceptions.dart';

/// Service interface for orchestrating the POS terminal payment flow.
abstract interface class TerminalPaymentServiceI {
  /// Starts the complete terminal payment flow.
  ///
  /// Flow:
  /// 1. Creates payment token via backend
  /// 2. Launches PrivatBank Terminal
  /// 3. Waits for deep link callback (with timeout)
  /// 4. Verifies payment via backend
  /// 5. Returns final PaymentResult
  ///
  /// Throws only [TerminalPaymentCancelledException] (cancel) or
  /// [TerminalPaymentException] subclasses (failure). Every
  /// repository/terminal/deep-link error is translated at this boundary; no
  /// implementation-specific exception escapes.
  Future<PaymentResult> startPayment(CreatePaymentRequest request);

  /// Aborts an in-flight [startPayment] from the UI side (cashier cancel).
  ///
  /// Completes the in-flight session's completer with a
  /// [TerminalPaymentCancelledException] so the caller observes a clean
  /// cancellation instead of a hang. A no-op when no payment is active, the
  /// session has already terminated, or the payment has already committed (a
  /// callback completed the completer first — we must not claim a cancellation
  /// after the terminal/backend may already have completed the charge).
  void cancelPayment();
}

/// Marker for every exception the terminal service can surface. The handler
/// maps these uniformly into the app-level [PaymentException], preserving the
/// [reason] so the boundary stays machine-readable.
abstract interface class TerminalPaymentException implements Exception {
  String get message;
  PaymentFailureReason get reason;
}

/// Payment outcome statuses carried by the terminal's callback URI.
///
/// This is PRRO's *internal* mapping of the terminal callback protocol — a
/// fixed set of `status` query-parameter strings shared only at the URI
/// level. The two apps never exchange Dart types.
enum PaymentStatus {
  /// Payment completed successfully (carries a `transactionId`).
  success,

  /// Payment was declined by the terminal (no `transactionId`).
  declined,

  /// Payment was cancelled by the user (no `transactionId`).
  cancelled,

  /// Payment encountered a terminal error (may carry an `errorCode`).
  error,

  /// Payment timed out at the terminal (no `transactionId`).
  timeout;

  /// Parses the terminal's `status` query parameter (case-insensitive).
  /// Returns `null` for any value outside the callback contract.
  static PaymentStatus? tryParse(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'success':
        return PaymentStatus.success;
      case 'declined':
        return PaymentStatus.declined;
      case 'error':
        return PaymentStatus.error;
      case 'cancelled':
      case 'canceled':
        return PaymentStatus.cancelled;
      case 'timeout':
        return PaymentStatus.timeout;
      default:
        return null;
    }
  }
}

/// Exception thrown when the terminal app cannot be launched.
class TerminalLaunchFailedException implements TerminalPaymentException {
  const TerminalLaunchFailedException(this.message);
  @override
  final String message;
  @override
  PaymentFailureReason get reason => PaymentFailureReason.terminalUnavailable;
  @override
  String toString() => 'TerminalLaunchFailedException: $message';
}

/// Exception thrown when the backend cannot take a terminal payment because it
/// does not expose the payment endpoints.
///
/// Raised by `PaymentRepositoryImpl` when the route is absent (a well-formed
/// request answered 404) or explicitly unimplemented (501). It is deliberately
/// *not* an [PaymentOperationException] with a generic message: the seller must
/// be able to tell "the server does not do card payments" from "something went
/// wrong", because the first one has a different next action (take cash).
///
/// The route, the method and the dialog option all stay in place — the backend
/// only has to implement the endpoint for this to stop firing.
class TerminalPaymentEndpointUnavailableException
    implements TerminalPaymentException {
  const TerminalPaymentEndpointUnavailableException([
    this.message = 'Оплата терміналом недоступна: сервер не підтримує '
        'такий спосіб оплати. Оберіть готівку.',
  ]);
  @override
  final String message;
  @override
  PaymentFailureReason get reason =>
      PaymentFailureReason.terminalEndpointUnavailable;
  @override
  String toString() => 'TerminalPaymentEndpointUnavailableException: $message';
}

/// Exception thrown when the payment callback times out.
class PaymentCallbackTimeoutException implements TerminalPaymentException {
  const PaymentCallbackTimeoutException(this.message);
  @override
  final String message;
  @override
  PaymentFailureReason get reason => PaymentFailureReason.terminalTimeout;
  @override
  String toString() => 'PaymentCallbackTimeoutException: $message';
}

/// Exception thrown when the callback URI is malformed.
class InvalidCallbackException implements TerminalPaymentException {
  const InvalidCallbackException(this.message);
  @override
  final String message;
  @override
  PaymentFailureReason get reason => PaymentFailureReason.invalidCallback;
  @override
  String toString() => 'InvalidCallbackException: $message';
}

/// Exception thrown when the terminal reports a payment failure without a
/// usable transaction id (e.g. `status=error`/`status=failed`).
class PaymentTerminalFailureException implements TerminalPaymentException {
  const PaymentTerminalFailureException(this.message);
  @override
  final String message;
  @override
  PaymentFailureReason get reason => PaymentFailureReason.terminalDeclined;
  @override
  String toString() => 'PaymentTerminalFailureException: $message';
}

/// Exception thrown when payment is cancelled at the terminal boundary.
///
/// Distinct from the app-level cancellation in `payment_exceptions.dart`
/// ([PaymentCancelledException]): this one carries the terminal-facing message
/// and travels across the `TerminalPaymentServiceI` boundary. The seller's
/// `TerminalPaymentHandler` translates it into the app-level type.
class TerminalPaymentCancelledException implements Exception {
  const TerminalPaymentCancelledException(this.message);
  final String message;
  @override
  String toString() => 'TerminalPaymentCancelledException: $message';
}

/// Exception thrown when `startPayment` is called while another payment
/// session is already active. Enforced by the single-active-session guard
/// (`activeSessionId`) as the strongest defense against stale/duplicate
/// callbacks from the global deep-link broadcast stream.
class PaymentAlreadyInProgressException implements TerminalPaymentException {
  const PaymentAlreadyInProgressException(this.message);
  @override
  final String message;
  @override
  PaymentFailureReason get reason => PaymentFailureReason.alreadyInProgress;
  @override
  String toString() => 'PaymentAlreadyInProgressException: $message';
}

/// Exception thrown for any unexpected internal/repository/deep-link failure
/// that is not one of the well-defined terminal/callback outcomes.
class PaymentOperationException implements TerminalPaymentException {
  PaymentOperationException(
    this.message,
    this.reason, {
    this.cause,
    this.stackTrace,
  });
  @override
  final String message;
  @override
  final PaymentFailureReason reason;
  final Object? cause;
  final StackTrace? stackTrace;
  @override
  String toString() => 'PaymentOperationException(${reason.name}): $message';
}
