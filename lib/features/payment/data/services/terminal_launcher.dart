import 'package:injectable/injectable.dart';
import 'package:prro/core/config/payment_config.dart';
import 'package:talker/talker.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service interface for launching the PrivatBank POS Terminal.
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
  TerminalLauncher(this.talker, this.paymentConfig);
  final Talker talker;
  final PaymentConfig paymentConfig;

  @override
  Future<void> launchTerminal({
    required String jwtToken,
    required int amount,
    required String currency,
    required String orderId,
    String? merchantId,
  }) async {
    final uriString = paymentConfig.buildTerminalUri(
      jwtToken: jwtToken,
      amount: amount,
      currency: currency,
      orderId: orderId,
      merchantId: merchantId,
    );
    final uri = Uri.parse(uriString);

    // The URI itself is not logged: it carries the terminal JWT (a bearer
    // credential for the charge). `buildTerminalUri` logs the redacted form.
    talker.info(
      '[TerminalLauncher] Attempting to launch terminal '
      '(${PaymentConfig.terminalUriScheme} scheme)',
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

      talker.info('[TerminalLauncher] Terminal launched successfully');
    } on TerminalLaunchException {
      rethrow;
    } on Exception catch (e, st) {
      talker.error('[TerminalLauncher] Failed to launch terminal', e, st);

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
