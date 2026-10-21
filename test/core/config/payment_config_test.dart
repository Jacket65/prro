import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/config/payment_config.dart';
import 'package:talker/talker.dart';

void main() {
  final config = PaymentConfig(
    Talker(settings: TalkerSettings(useConsoleLogs: false)),
  );

  group('PaymentConfig.isCallback', () {
    test('accepts the callback this app launches the terminal with', () {
      expect(PaymentConfig.isCallback(Uri.parse('prro://payment')), isTrue);
      expect(
        PaymentConfig.isCallback(
          Uri.parse('prro://payment?transaction_id=tx-1&status=SUCCESS'),
        ),
        isTrue,
      );
    });

    test('rejects a matching scheme on a different host', () {
      expect(PaymentConfig.isCallback(Uri.parse('prro://refund')), isFalse);
    });

    test('rejects a matching host on a different scheme', () {
      expect(
        PaymentConfig.isCallback(Uri.parse('privatpay://payment')),
        isFalse,
      );
    });

    test('rejects an unrelated URI', () {
      expect(
        PaymentConfig.isCallback(Uri.parse('https://example.com')),
        isFalse,
      );
      expect(PaymentConfig.isCallback(Uri.parse('about:blank')), isFalse);
    });

    test('compares scheme and host only, so a path does not disqualify', () {
      expect(
        PaymentConfig.isCallback(Uri.parse('prro://payment/extra')),
        isTrue,
      );
    });
  });

  group('PaymentConfig.buildTerminalUri', () {
    test('still returns the full URI the terminal needs', () {
      final uri = config.buildTerminalUri(
        jwtToken: 'jwt-abc.def-ghi',
        amount: 1500,
        currency: 'UAH',
        orderId: 'order-1',
        merchantId: 'merchant-1',
      );

      // The launch path must keep the credential: the terminal reads it from
      // the query string. Only the *logging* of it changes.
      expect(uri, contains('token=jwt-abc.def-ghi'));
      expect(uri, startsWith('privatpay://pay?'));
    });
  });

  group('PaymentConfig.redactedTerminalUri', () {
    Uri terminalUri({
      String token = 'jwt-abc.def-ghi',
      String? merchantId = 'merchant-1',
    }) => Uri.parse(
      config.buildTerminalUri(
        jwtToken: token,
        amount: 1500,
        currency: 'UAH',
        orderId: 'order-1',
        merchantId: merchantId,
      ),
    );

    test('never emits the terminal JWT', () {
      final redacted = PaymentConfig.redactedTerminalUri(
        terminalUri(token: 'super.secret.jwt'),
      );

      expect(redacted, isNot(contains('super.secret.jwt')));
      expect(redacted, isNot(contains('secret')));
      expect(redacted, contains('token: ${PaymentConfig.redactedToken}'));
    });

    test('emits no `token=` substring, so the placeholder cannot be read as a '
        'query parameter that carries a value', () {
      final redacted = PaymentConfig.redactedTerminalUri(terminalUri());

      expect(redacted, isNot(contains('token=')));
    });

    test('keeps the fields that identify the charge', () {
      final redacted = PaymentConfig.redactedTerminalUri(terminalUri());

      expect(redacted, startsWith('privatpay://pay?'));
      expect(redacted, contains('amount=1500'));
      expect(redacted, contains('currency=UAH'));
      expect(redacted, contains('orderId=order-1'));
      expect(redacted, contains('merchantId=merchant-1'));
    });

    test('omits merchantId when the terminal has none', () {
      final redacted = PaymentConfig.redactedTerminalUri(
        terminalUri(merchantId: null),
      );

      expect(redacted, isNot(contains('merchantId')));
      expect(redacted, contains('amount=1500'));
    });
  });
}
