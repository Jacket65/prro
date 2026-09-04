import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:prro/config/payment_config.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service interface for launching the PrivatBank NFC POS Terminal.
// ignore: one_member_abstracts
abstract interface class TerminalLauncherI {
  /// Launches the PrivatBank Terminal with the given payment details.
  /// Throws [TerminalLaunchException] if the launch fails.
  Future<void> launchTerminal({
    required String jwtToken,
    required int amount,
    required String currency,
    required String orderId,
    String? merchantId,
  });
}

/// Production implementation of [TerminalLauncherI].
@LazySingleton(as: TerminalLauncherI)
class TerminalLauncher implements TerminalLauncherI {
  TerminalLauncher();

  @override
  Future<void> launchTerminal({
    required String jwtToken,
    required int amount,
    required String currency,
    required String orderId,
    String? merchantId,
  }) async {
    final uriString = PaymentConfig.buildTerminalUri(
      jwtToken: jwtToken,
      amount: amount,
      currency: currency,
      orderId: orderId,
      merchantId: merchantId,
    );
    final uri = Uri.parse(uriString);

    // Console log for debugging
    log('[TerminalLauncher] Attempting to launch URI: $uriString');
    log(
      '[TerminalLauncher] Terminal scheme: ${PaymentConfig.terminalUriScheme}',
    );
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw const TerminalLaunchException(
          'Не вдалося відкрити PrivatBank Terminal. '
          'Переконайтеся, що застосунок встановлено.',
        );
      }

      log('[TerminalLauncher] Terminal launched successfully');
    } on TerminalLaunchException {
      rethrow;
    } on Exception catch (e, st) {
      log(
        '[TerminalLauncher] Failed to launch terminal',
        error: e,
        stackTrace: st,
      );

      throw TerminalLaunchException(
        'Не вдалося відкрити PrivatBank Terminal: $e',
      );
    }
  }
}

/// Exception thrown when terminal launch fails with details.
class TerminalLaunchException implements Exception {
  const TerminalLaunchException(this.message);
  final String message;
  @override
  String toString() => 'TerminalLaunchException: $message';
}
