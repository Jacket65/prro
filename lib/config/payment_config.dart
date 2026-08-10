import 'dart:developer';

/// Payment configuration constants.
///
/// All values are configurable and should not be hardcoded in business logic.
class PaymentConfig {
  PaymentConfig._();

  /// Deep link callback scheme (e.g., 'prro').
  static const String callbackScheme = 'prro';

  /// Deep link callback host (e.g., 'payment').
  static const String callbackHost = 'payment';

  /// Full callback URI used when launching the PrivatBank Terminal.
  static String get callbackUri => '$callbackScheme://$callbackHost';

  /// Payment timeout duration.
  static const Duration paymentTimeout = Duration(seconds: 120);

  /// PrivatBank NFC POS Terminal URI scheme.
  /// Change this to match your mock terminal app's scheme
  /// (e.g., 'mocknfc', 'testterminal')
  static const String terminalUriScheme = 'privatpay';

  /// Terminal pay action path.
  static const String terminalPayPath = 'pay';

  /// Builds the terminal launch URI with the given JWT token.
  static String buildTerminalUri(String jwtToken) {
    final uri = Uri(
      scheme: terminalUriScheme,
      host: terminalPayPath,
      queryParameters: {
        'token': jwtToken,
        'callback': callbackUri,
      },
    );
    final uriString = uri.toString();
    log('[PaymentConfig] Built terminal URI: $uriString');
    return uriString;
  }
}
