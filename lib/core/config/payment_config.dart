import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

@lazySingleton
class PaymentConfig {
  PaymentConfig(this.talker);
  final Talker talker;

  /// Deep link callback scheme (e.g., 'prro').
  static const String callbackScheme = 'prro';

  /// Deep link callback host (e.g., 'payment').
  static const String callbackHost = 'payment';

  /// Full callback URI used when launching the PrivatBank Terminal.
  static String get callbackUri => '$callbackScheme://$callbackHost';

  /// Whether [uri] is a payment callback this app launched the terminal with.
  ///
  /// Both sides of the flow ask this, so they cannot disagree.
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
  /// The token is a bearer credential for a card charge, so every log line
  /// that mentions a terminal URI goes through [redactedTerminalUri].
  static const String redactedToken = '***';

  /// Log-safe rendering of a terminal launch [uri].
  ///
  /// Keeps only the fields that identify a charge and replaces the JWT with
  /// [redactedToken]. Assembled by hand rather than from `uri.toString()` so
  /// a caller cannot re-emit the credential by formatting the original.
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
  String buildTerminalUri({
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
    // Only the redacted form reaches the log: [jwtToken] authorizes a charge
    // against the terminal.
    talker.info(
      '[PaymentConfig] Built terminal URI: ${redactedTerminalUri(uri)}',
    );
    return uriString;
  }
}
