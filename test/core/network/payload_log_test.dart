import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/network/payload_log.dart';

void main() {
  group('describePayload', () {
    test('returns null for a missing payload', () {
      expect(describePayload(null), isNull);
    });

    test('pretty-prints a map payload', () {
      final result = describePayload({
        'order_id': 7,
        'items': [
          {'name': 'coffee', 'qty': 2},
        ],
      });

      expect(result, contains('"order_id": 7'));
      expect(result, contains('"name": "coffee"'));
      expect(result, contains('"qty": 2'));
    });

    test('redacts credential values at the top level', () {
      final result = describePayload({
        'login': 'user',
        'password': 'super-secret',
      });

      expect(result, contains('"login": "user"'));
      expect(result, isNot(contains('super-secret')));
      expect(result, contains(redactedValue));
    });

    test('redacts credential values nested in maps and lists', () {
      final result = describePayload({
        'session': {
          'refresh_token': 'r-secret',
          'user': {'id': 3},
        },
        'payments': [
          {'card_number': '4242424242424242', 'amount': 100},
        ],
      });

      expect(result, isNot(contains('r-secret')));
      expect(result, isNot(contains('4242424242424242')));
      expect(result, contains('"id": 3'));
      expect(result, contains('"amount": 100'));
    });

    test('decodes a JSON string payload before printing it', () {
      final result = describePayload('{"total": 250, "paid": true}');

      expect(result, contains('"total": 250'));
      expect(result, contains('"paid": true'));
    });

    test('keeps a non-JSON string payload readable', () {
      expect(describePayload('not-json'), 'not-json');
    });

    test('truncates a payload that exceeds the log limit', () {
      final blob = 'x' * (maxLoggedPayloadLength * 2);
      final result = describePayload({'blob': blob});

      expect(result, isNotNull);
      expect(result!.length, lessThan(maxLoggedPayloadLength + 40));
      expect(result, contains('(truncated)'));
    });
  });

  group('isSensitiveKey', () {
    test('detects exact and fragment matches', () {
      expect(isSensitiveKey('password'), isTrue);
      expect(isSensitiveKey('new_password'), isTrue);
      expect(isSensitiveKey('access_token'), isTrue);
      expect(isSensitiveKey('api_key'), isTrue);
      expect(isSensitiveKey('Authorization'), isTrue);
    });

    test('leaves ordinary keys alone', () {
      expect(isSensitiveKey('order_id'), isFalse);
      expect(isSensitiveKey('items'), isFalse);
    });
  });
}
