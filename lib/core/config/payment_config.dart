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

  /// Whether [uri] is a payment callback this app launched the terminal with.
  ///
  /// The single definition of the rule: both sides of the flow ask this, the
  /// listener before emitting (`DeepLinkService`) and the orchestrator on
  /// receipt (`TerminalPaymentService`). Keeping one copy means a change to
  /// [callbackScheme] or [callbackHost] cannot leave the two disagreeing about
  /// which URIs count.
  static bool isCallback(Uri uri) =>
      uri.scheme == callbackScheme && uri.host == callbackHost;

  /// Payment timeout duration.
  static const Duration paymentTimeout = Duration(seconds: 120);

  /// PrivatBank POS Terminal URI scheme.
  /// Change this to match your mock terminal app's scheme
  /// (e.g., 'mockterminal', 'testterminal')
  static const String terminalUriScheme = 'privatpay';

  /// Terminal pay action path.
  static const String terminalPayPath = 'pay';

  /// Builds the terminal launch URI with the given payment details.
  static String buildTerminalUri({
    required String jwtToken,
    required int amount,
    required String currency,
    required String orderId,
    String? merchantId,
  }) {
    final uri = Uri(
      scheme: terminalUriScheme,
      host: terminalPayPath,
      queryParameters: {
        'token': jwtToken,
        'callback': callbackUri,
        'amount': amount.toString(),
        'currency': currency,
        'orderId': orderId,
        'merchantId': ?merchantId,
      },
    );
    final uriString = uri.toString();
    log('[PaymentConfig] Built terminal URI: $uriString');
    return uriString;
  }
}
