import 'package:prro/core/logging/app_talker.dart';

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

  /// Placeholder written in place of the PrivatBank JWT in every log line.
  ///
  /// The token is a bearer credential for a card charge, so a full copy in a
  /// log line is a credential leak — the same rule `TerminalToken.toString`
  /// applies. Every log line that mentions a terminal URI goes through
  /// [redactedTerminalUri] instead of formatting the URI directly.
  static const String redactedToken = '***';

  /// Log-safe rendering of a terminal launch [uri].
  ///
  /// Keeps only the fields that identify a charge in a log — scheme, pay
  /// action, amount, currency, order id, merchant id — and replaces the JWT
  /// with [redactedToken]. Assembled by hand rather than from `uri.toString()`
  /// so a caller cannot re-emit the credential by formatting the original, and
  /// so the placeholder is never percent-encoded back into a token-looking
  /// query value.
  static String redactedTerminalUri(Uri uri) {
    final query = uri.queryParameters;
    final fields = <String>[
      if (query['amount'] != null) 'amount=${query['amount']}',
      if (query['currency'] != null) 'currency=${query['currency']}',
      if (query['orderId'] != null) 'orderId=${query['orderId']}',
      if (query['merchantId'] != null) 'merchantId=${query['merchantId']}',
      'token: $redactedToken',
    ];
    return '$terminalUriScheme://$terminalPayPath?${fields.join('&')}';
  }

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
    // Only the redacted form may reach the log: [jwtToken] authorizes a charge
    // against the terminal, so a full URI in a log line leaks the credential.
    appTalker.info(
      '[PaymentConfig] Built terminal URI: ${redactedTerminalUri(uri)}',
    );
    return uriString;
  }
}
