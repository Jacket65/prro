import 'dart:async';

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
class NfcPaymentService implements NfcPaymentServiceI {
  NfcPaymentService({
    required this._paymentRepository,
    required this._terminalLauncher,
    required this._deepLinkService,
    required this._talker,
    Duration? paymentTimeout,
  }) : _paymentTimeout = paymentTimeout ?? PaymentConfig.paymentTimeout;

  final PaymentRepositoryI _paymentRepository;
  final TerminalLauncherI _terminalLauncher;
  final DeepLinkServiceI _deepLinkService;
  final Talker _talker;
  final Duration _paymentTimeout;

  @override
  Future<PaymentResult> startPayment(CreatePaymentRequest request) async {
    _talker
      ..info('🔵 [NFC Payment] Starting payment flow', request.toString())
      // Step 1: Create payment token
      ..info('🔵 [NFC Payment] Creating payment token...');
    final token = await _paymentRepository.createPaymentToken(request);
    _talker
      ..info('🟢 [NFC Payment] Token received', token.toString())
      // Step 2: Launch terminal
      ..info('🔵 [NFC Payment] Launching PrivatBank Terminal...');
    final launched = await _terminalLauncher.launchTerminal(token.token);
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
    final transactionId = await _waitForCallback();
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
    final completer = Completer<String>();
    late StreamSubscription<Uri> subscription;

    // Set up timeout
    final timeoutTimer = Timer(_paymentTimeout, () {
      if (!completer.isCompleted) {
        _talker.warning(
          '🟡 [NFC Payment] Payment timeout after'
          '${_paymentTimeout.inSeconds}s',
        );
        completer.completeError(
          const PaymentCallbackTimeoutException(
            'Час очікування оплати вийшов. Спробуйте ще раз.',
          ),
        );
      }
    });

    // Listen for callback
    subscription = _deepLinkService.onDeepLink.listen((uri) {
      if (!completer.isCompleted) {
        final transactionId = _extractTransactionId(uri);
        if (transactionId != null) {
          _talker.info(
            '🟢 [NFC Payment] Extracted transactionId from callback',
            transactionId,
          );
          completer.complete(transactionId);
        } else {
          _talker.warning(
            '🟡 [NFC Payment] Callback received but no transactionId found',
            uri.toString(),
          );
          completer.completeError(
            InvalidCallbackException('Невірний формат callback: $uri'),
          );
        }
      }
    });

    try {
      return await completer.future;
    } finally {
      timeoutTimer.cancel();
      await subscription.cancel();
    }
  }

  /// Extracts transaction ID from the callback URI.
  String? _extractTransactionId(Uri uri) {
    // Expected format: prro://payment?transaction_id=xxx&status=xxx
    return uri.queryParameters['transaction_id'] ??
        uri.queryParameters['transactionId'];
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
