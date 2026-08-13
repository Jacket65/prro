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
    final callbackFuture = _waitForCallback();

    // Step 2: Launch terminal
    final orderId =
        request.orderId ?? 'order_${DateTime.now().millisecondsSinceEpoch}';
    _talker.info('🔵 [NFC Payment] Launching PrivatBank Terminal...');
    final launched = await _terminalLauncher.launchTerminal(
      jwtToken: token.token,
      amount: request.amount,
      currency: request.currency,
      orderId: orderId,
      merchantId: request.metadata?['merchantId'] as String?,
    );
    if (!launched) {
      _talker.error('🔴 [NFC Payment] Failed to launch terminal');
      throw const TerminalLaunchFailedException(
        'Не вдалося відкрити термінал PrivatBank. '
        'Переконайтеся, що застосунок встановлено.',
      );
    }
    _talker
      ..info('🟢 [NFC Payment] Terminal launched successfully')
      // Step 3: Wait for callback with timeout
      ..info('🔵 [NFC Payment] Waiting for payment callback...');
    final transactionId = await callbackFuture;
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
  }

  /// Waits for the deep link callback with a timeout.
  Future<String> _waitForCallback() async {
    try {
      final uri = await _deepLinkService.onDeepLink
          .firstWhere(
            (uri) => _extractTransactionId(uri) != null,
          )
          .timeout(_paymentTimeout);

      final transactionId = _extractTransactionId(uri)!;

      _talker.info(
        '🟢 [NFC Payment] Extracted transactionId',
        transactionId,
      );

      return transactionId;
    } on TimeoutException {
      _talker.warning(
        '🟡 [NFC Payment] Payment timeout after '
        '${_paymentTimeout.inSeconds}s',
      );

      throw const PaymentCallbackTimeoutException(
        'Час очікування оплати вийшов. Спробуйте ще раз.',
      );
    }
  }

  /// Extracts transaction ID from the callback URI.
  String? _extractTransactionId(Uri uri) {
    final transactionId =
        uri.queryParameters['transaction_id'] ??
        uri.queryParameters['transactionId'];

    if (transactionId == null || transactionId.isEmpty) {
      return null;
    }

    return transactionId;
  }
}

/// Exception thrown when the terminal app cannot be launched.
class TerminalLaunchFailedException implements Exception {
  const TerminalLaunchFailedException(this.message);
  final String message;
  @override
  String toString() => 'TerminalLaunchFailedException: $message';
}

/// Exception thrown when the terminal launch fails with details.
class TerminalLaunchException implements Exception {
  const TerminalLaunchException(this.message);
  final String message;
  @override
  String toString() => 'TerminalLaunchException: $message';
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

/// Exception thrown when payment is cancelled by user.
class PaymentCancelledException implements Exception {
  const PaymentCancelledException(this.message);
  final String message;
  @override
  String toString() => 'PaymentCancelledException: $message';
}

/// Exception thrown when payment verification fails.
class PaymentVerificationFailedException implements Exception {
  const PaymentVerificationFailedException(this.message);
  final String message;
  @override
  String toString() => 'PaymentVerificationFailedException: $message';
}
