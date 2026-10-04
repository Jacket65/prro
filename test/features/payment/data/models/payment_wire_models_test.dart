import 'package:flutter_test/flutter_test.dart';
import 'package:prro/features/payment/data/models/payment_result.dart';
import 'package:prro/features/payment/data/models/payment_token.dart';

void main() {
  group('TerminalToken.fromJson', () {
    test('two tokens decoded from the same payload are structurally equal', () {
      const payload = {
        'token': 'eyJhbGciOiJIUzI1NiJ9.payload.signature',
        'expires': '2026-10-04T15:30:00Z',
      };
      expect(TerminalToken.fromJson(payload), TerminalToken.fromJson(payload));
    });

    test('parses token and expires', () {
      final token = TerminalToken.fromJson(const {
        'token': 'eyJhbGciOiJIUzI1NiJ9.payload.signature',
        'expires': '2026-10-04T15:30:00Z',
      });
      expect(token.token, 'eyJhbGciOiJIUzI1NiJ9.payload.signature');
      expect(token.expiresAt, DateTime.utc(2026, 10, 4, 15, 30).toLocal());
    });

    test('a missing token is empty rather than a decode error', () {
      expect(TerminalToken.fromJson(const {}).token, isEmpty);
    });

    test('a missing expires leaves the terminal a ten-minute window', () {
      final before = DateTime.now().add(const Duration(minutes: 10));
      final token = TerminalToken.fromJson(const {});
      final after = DateTime.now().add(const Duration(minutes: 10));

      expect(token.expiresAt.isBefore(before), isFalse);
      expect(token.expiresAt.isAfter(after), isFalse);
    });

    test('a malformed expires falls back the same way as a missing one', () {
      final before = DateTime.now().add(const Duration(minutes: 10));
      final token = TerminalToken.fromJson(const {'expires': 'not-a-date'});

      expect(token.expiresAt.isBefore(before), isFalse);
    });

    test('toString truncates the JWT', () {
      const jwt = 'eyJhbGciOiJIUzI1NiJ9.super-secret-signature';
      final printed = TerminalToken(
        token: jwt,
        expiresAt: DateTime.utc(2026, 10, 4, 15, 30),
      ).toString();

      expect(printed, contains('eyJhbGciOi'));
      expect(printed, isNot(contains('super-secret-signature')));
    });
  });

  group('PaymentResult.fromJson', () {
    test(
      'two results decoded from the same payload are structurally equal',
      () {
        const payload = {
          'success': true,
          'status': 'SUCCESS',
          'amount': 5000,
          'card_mask': '5168 **** **** 1234',
        };
        expect(
          PaymentResult.fromJson(payload),
          PaymentResult.fromJson(payload),
        );
      },
    );

    test('parses every wire field', () {
      final result = PaymentResult.fromJson(const {
        'success': true,
        'status': 'SUCCESS',
        'rrn': '123456789',
        'amount': 5000,
        'transaction_id': 'tx-1',
        'card_mask': '5168 **** **** 1234',
        'auth_code': '654321',
      });

      expect(result.success, isTrue);
      expect(result.status, 'SUCCESS');
      expect(result.rrn, '123456789');
      expect(result.amount, 5000);
      expect(result.transactionId, 'tx-1');
      expect(result.cardMask, '5168 **** **** 1234');
      expect(result.authCode, '654321');
    });

    test('a missing success is false', () {
      expect(PaymentResult.fromJson(const {}).success, isFalse);
    });

    test('the string "true" is not a success', () {
      expect(
        PaymentResult.fromJson(const {'success': 'true'}).success,
        isFalse,
      );
    });

    test('a missing status is empty rather than a decode error', () {
      expect(PaymentResult.fromJson(const {}).status, isEmpty);
    });

    test('amount accepts the kopecks string and the bare number alike', () {
      expect(PaymentResult.fromJson(const {'amount': '5000'}).amount, 5000);
      expect(PaymentResult.fromJson(const {'amount': 5000}).amount, 5000);
    });

    test('a missing amount is null', () {
      expect(PaymentResult.fromJson(const {}).amount, isNull);
    });

    // Deliberate widening: `parseNullableInt` degrades an unparseable amount
    // to 0 kopecks where the old hand-written `int.tryParse` gave null. Pinned
    // here so it stays a decision; no production code reads `amount` today.
    test('a non-numeric amount degrades to 0 kopecks', () {
      expect(PaymentResult.fromJson(const {'amount': 'many'}).amount, 0);
    });

    test('a failed payment carries no optional acquirer fields', () {
      final result = PaymentResult.fromJson(const {
        'success': false,
        'status': 'FAILED',
      });

      expect(result.rrn, isNull);
      expect(result.transactionId, isNull);
      expect(result.cardMask, isNull);
      expect(result.authCode, isNull);
    });
  });
}
