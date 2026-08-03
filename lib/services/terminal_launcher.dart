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

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      return launched;
    } on Object catch (_) {
      // Launch failed - terminal app not installed or other error
      return false;
    }
  }
}
