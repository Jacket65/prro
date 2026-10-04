import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/config/payment_config.dart';

void main() {
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
}
