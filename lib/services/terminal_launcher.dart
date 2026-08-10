import 'dart:developer';

import 'package:prro/config/payment_config.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service interface for launching the PrivatBank NFC POS Terminal.
// ignore: one_member_abstracts
abstract interface class TerminalLauncherI {
  /// Launches the PrivatBank Terminal with the given JWT token.
  /// Returns true if the launch was successful, false otherwise.
  Future<bool> launchTerminal(String jwtToken);
}

/// Production implementation of [TerminalLauncherI].
class TerminalLauncher implements TerminalLauncherI {
  TerminalLauncher();

  @override
  Future<bool> launchTerminal(String jwtToken) async {
    final uriString = PaymentConfig.buildTerminalUri(jwtToken);
    final uri = Uri.parse(uriString);

    // Console log for debugging
    log('[TerminalLauncher] Attempting to launch URI: $uriString');
    log(
      '[TerminalLauncher] Terminal scheme: ${PaymentConfig.terminalUriScheme}',
    );

    // Pre-check: verify the terminal app can be launched
    final canLaunch = await canLaunchUrl(uri);
    log('[TerminalLauncher] canLaunchUrl check: $canLaunch');
    if (!canLaunch) {
      log(
        '[TerminalLauncher] ERROR: No app handles scheme '
        '"${PaymentConfig.terminalUriScheme}"',
      );
      throw const TerminalLaunchException(
        'PrivatBank Terminal app (scheme: ${PaymentConfig.terminalUriScheme}) '
        'is not installed. Please install the mock terminal app.',
      );
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      log('[TerminalLauncher] Launch result: $launched');
      return launched;
    } on TerminalLaunchException {
      rethrow;
    } on Exception catch (e) {
      // Console log for debugging
      log('[TerminalLauncher] ERROR: $e');
      // Log the specific error for debugging
      throw TerminalLaunchException(
        'Failed to launch PrivatBank Terminal: $e',
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
