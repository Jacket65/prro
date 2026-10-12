import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/config/network_timeouts.dart';
import 'package:prro/core/config/payment_config.dart';

void main() {
  group('NetworkTimeouts', () {
    test('standard is the pre-existing 10 s default', () {
      expect(NetworkTimeouts.standard, const Duration(seconds: 10));
    });

    test('auth is long enough for login plus its outlet fallback', () {
      expect(NetworkTimeouts.auth, const Duration(seconds: 15));
      expect(
        NetworkTimeouts.auth,
        greaterThan(NetworkTimeouts.standard),
      );
    });

    test('payment matches the terminal session bound', () {
      expect(NetworkTimeouts.payment, PaymentConfig.paymentTimeout);
      expect(NetworkTimeouts.payment, const Duration(seconds: 120));
    });
  });
}
