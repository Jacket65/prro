import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:prro/config/payment_config.dart';
import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/api/models/payment/payment_result.dart';
import 'package:prro/data/repositories/payment_repository/payment_repo_i.dart';
import 'package:prro/services/deep_link_service.dart';
import 'package:prro/services/terminal_launcher.dart';
import 'package:talker/talker.dart';

/// Service interface for orchestrating the NFC POS payment flow.
// ignore: one_member_abstracts
abstract interface class NfcPaymentServiceI {
  /// Starts the complete NFC payment flow.
  ///
  /// Flow:
  /// 1. Creates payment token via backend
  /// 2. Launches PrivatBank Terminal
  /// 3. Waits for deep link callback (with timeout)
  /// 4. Verifies payment via backend
  /// 5. Returns final PaymentResult
  Future<PaymentResult> startPayment(CreatePaymentRequest request);
}

/// Production implementation of [NfcPaymentServiceI].
@LazySingleton(as: NfcPaymentServiceI)
class NfcPaymentService implements NfcPaymentServiceI {
  NfcPaymentService({
    required this._paymentRepository,
    required this._terminalLauncher,
    required this._deepLinkService,
    required this._talker,
  });

  final PaymentRepositoryI _paymentRepository;
  final TerminalLauncherI _terminalLauncher;
  final DeepLinkServiceI _deepLinkService;
  final Talker _talker;
  Duration _paymentTimeout = PaymentConfig.paymentTimeout;

  /// Callback timeout (defaults to [PaymentConfig.paymentTimeout]).
  Duration get paymentTimeout => _paymentTimeout;

  /// Overrides the callback timeout (used by tests).
  @visibleForTesting
  set paymentTimeout(Duration timeout) => _paymentTimeout = timeout;

  @override
  Future<PaymentResult> startPayment(CreatePaymentRequest request) async {
    _talker
      ..info('🔵 [NFC Payment] Starting payment flow', request.toString())
      // Step 1: Create payment token
      ..info('🔵 [NFC Payment] Creating payment token...');
    final token = await _paymentRepository.createPaymentToken(request);
    _talker.info('🟢 [NFC Payment] Token received', token.toString());

    final orderId =
        request.orderId ?? 'order_${DateTime.now().millisecondsSinceEpoch}';

    // Subscribe before launching the terminal so we never miss an immediate
    // redirect. The subscription is owned locally and always torn down in the
    // `finally` block. The callback timeout starts only after the terminal
    // launches successfully.
    final completer = Completer<String>();
    Timer? timer;

    final subscription = _deepLinkService.onDeepLink.listen(
      (uri) {
        if (completer.isCompleted) return;

        try {
          final transactionId = _validateCallback(uri, orderId);
          completer.complete(transactionId);
        } on PaymentCancelledException catch (e, st) {
          completer.completeError(e, st);
        } on PaymentCallbackTimeoutException catch (e, st) {
          completer.completeError(e, st);
        } on PaymentTerminalFailureException catch (e, st) {
          completer.completeError(e, st);
        } on InvalidCallbackException catch (e) {
          _talker.warning(
            '🟡 [NFC Payment] Ignoring invalid callback: ${e.message}',
          );
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      },
    );
    try {
      // Step 2: Launch terminal
      _talker.info('🔵 [NFC Payment] Launching PrivatBank Terminal...');
      await _terminalLauncher.launchTerminal(
        jwtToken: token.token,
        amount: request.amount,
        currency: request.currency,
        orderId: orderId,
        merchantId: request.metadata?['merchantId']?.toString(),
      );
      _talker.info('🟢 [NFC Payment] Terminal launched successfully');

      timer = Timer(_paymentTimeout, () {
        if (!completer.isCompleted) {
          completer.completeError(
            const PaymentCallbackTimeoutException(
              'Час очікування оплати вийшов. Спробуйте ще раз.',
            ),
          );
        }
      });

      _talker.info('🔵 [NFC Payment] Waiting for payment callback...');

      final transactionId = await completer.future;
      _talker
        ..info(
          '🟢 [NFC Payment] Callback received',
          'transactionId: $transactionId',
        )
        // Step 4: Verify payment
        ..info('🔵 [NFC Payment] Verifying payment...');
      final result = await _paymentRepository.verifyPayment(transactionId);
      _talker.info('🟢 [NFC Payment] Verification complete', result.toString());

      return result;
    } on TerminalLaunchException {
      _talker.error('🔴 [NFC Payment] Failed to launch terminal');
      // throw const TerminalLaunchFailedException(
      //   'Не вдалося відкрити термінал PrivatBank. '
      //   'Переконайтеся, що застосунок встановлено.',
      // );
      rethrow;
    } on PaymentCancelledException {
      _talker.warning('🟡 [NFC Payment] Payment cancelled by terminal/user');
      rethrow;
    } finally {
      timer?.cancel();
      await subscription.cancel();
    }
  }

  /// Validates an incoming callback URI and returns its transaction id.
  ///
  /// Throws:
  /// - [PaymentCancelledException] when the terminal reports cancellation.
  /// - [PaymentTerminalFailureException] when the terminal reports a failure
  ///   without a usable transaction id.
  /// - [InvalidCallbackException] for any other malformed / untrusted callback.
  String _validateCallback(Uri uri, String orderId) {
    if (!_isPaymentCallback(uri)) {
      throw const InvalidCallbackException(
        'Callback URI does not match the expected payment scheme/host.',
      );
    }

    final params = uri.queryParameters;

    // Explicit status validation against the callback contract: a missing or
    // unknown `status` is rejected so it can never reach [verifyPayment].
    final status = PaymentStatus.tryParse(params['status']);
    if (status == null) {
      throw const InvalidCallbackException(
        'Callback contains an unknown or missing payment status.',
      );
    }

    switch (status) {
      case PaymentStatus.cancelled:
        throw const PaymentCancelledException('Оплату скасовано у терміналі.');
      case PaymentStatus.timeout:
        throw const PaymentCallbackTimeoutException(
          'Оплату перервано за таймаутом у терміналі.',
        );
      case PaymentStatus.error:
        final errorCode = params['errorCode'];
        final message = errorCode != null && errorCode.isNotEmpty
            ? 'Помилка терміналу (код: $errorCode).'
            : 'Помилка терміналу.';
        throw PaymentTerminalFailureException(message);
      case PaymentStatus.declined:
        throw const PaymentTerminalFailureException(
          'Термінал відхилив оплату.',
        );
      case PaymentStatus.success:
        break;
    }

    // Only a `success` callback reaches here and must carry a usable id.
    final transactionId = params['transaction_id'] ?? params['transactionId'];

    if (transactionId == null ||
        transactionId.isEmpty ||
        !_isWellFormedTransactionId(transactionId)) {
      throw const InvalidCallbackException(
        'Callback is missing or has an invalid transaction_id.',
      );
    }

    // Stricter cross-check: if the terminal echoes the order id, it must match
    // the payment we initiated.
    final callbackOrderId = params['orderId'] ?? params['order_id'];
    if (callbackOrderId != null &&
        callbackOrderId.isNotEmpty &&
        callbackOrderId != orderId) {
      throw const InvalidCallbackException(
        'Callback orderId does not match the initiated payment.',
      );
    }

    _talker.info(
      '🟢 [NFC Payment] Extracted transactionId',
      transactionId,
    );

    return transactionId;
  }

  /// Returns true when [id] looks like a valid transaction identifier
  /// (6–64 alphanumeric, dash or underscore characters).
  bool _isWellFormedTransactionId(String id) =>
      _transactionIdPattern.hasMatch(id);

  /// Whitelist for transaction id format to reject obviously malformed values.
  final RegExp _transactionIdPattern = RegExp(r'^[A-Za-z0-9_-]{6,64}$');

  /// Defensive check mirroring [DeepLinkService._isPaymentCallback].
  bool _isPaymentCallback(Uri uri) =>
      uri.scheme == PaymentConfig.callbackScheme &&
      uri.host == PaymentConfig.callbackHost;
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
class TerminalLaunchFailedException implements Exception {
  const TerminalLaunchFailedException(this.message);
  final String message;
  @override
  String toString() => 'TerminalLaunchFailedException: $message';
}

/// Exception thrown when the payment callback times out.
class PaymentCallbackTimeoutException implements Exception {
  const PaymentCallbackTimeoutException(this.message);
  final String message;
  @override
  String toString() => 'PaymentCallbackTimeoutException: $message';
}

/// Exception thrown when the callback URI is malformed.
class InvalidCallbackException implements Exception {
  const InvalidCallbackException(this.message);
  final String message;
  @override
  String toString() => 'InvalidCallbackException: $message';
}

/// Exception thrown when the terminal reports a payment failure without a
/// usable transaction id (e.g. `status=error`/`status=failed`).
class PaymentTerminalFailureException implements Exception {
  const PaymentTerminalFailureException(this.message);
  final String message;
  @override
  String toString() => 'PaymentTerminalFailureException: $message';
}

/// Exception thrown when payment is cancelled by user.
class PaymentCancelledException implements Exception {
  const PaymentCancelledException(this.message);
  final String message;
  @override
  String toString() => 'PaymentCancelledException: $message';
}
