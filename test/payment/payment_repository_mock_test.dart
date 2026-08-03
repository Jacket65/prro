import 'package:flutter_test/flutter_test.dart';
import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/api/models/payment/payment_result.dart';
import 'package:prro/data/api/models/payment/payment_token.dart';
import 'package:prro/data/repositories/payment_repository/payment_repository_mock.dart';

void main() {
  group('PaymentRepositoryMock', () {
    late PaymentRepositoryMock repository;

    setUp(() {
      repository = PaymentRepositoryMock();
    });

    test('createPaymentToken returns a valid TerminalToken', () async {
      const request = CreatePaymentRequest(
        amount: 15000,
        currency: 'UAH',
        description: 'Test payment',
      );

      final token = await repository.createPaymentToken(request);

      expect(token, isA<TerminalToken>());
      expect(token.token, isNotEmpty);
      expect(token.token, startsWith('mock_jwt_token_'));
      expect(token.expiresAt.isAfter(DateTime.now()), isTrue);
      expect(repository.lastRequest, equals(request));
    });

    test('verifyPayment returns a successful PaymentResult', () async {
      const request = CreatePaymentRequest(
        amount: 15000,
        currency: 'UAH',
        description: 'Test payment',
      );
      await repository.createPaymentToken(request);

      final result = await repository.verifyPayment('txn_12345');

      expect(result, isA<PaymentResult>());
      expect(result.success, isTrue);
      expect(result.status, equals('SUCCESS'));
      expect(result.amount, equals(15000));
      expect(result.transactionId, equals('txn_12345'));
      expect(result.cardMask, equals('5168 **** **** 1234'));
      expect(result.authCode, equals('123456'));
      expect(repository.lastResult, equals(result));
    });

    test('verifyPayment uses amount from last request', () async {
      const request = CreatePaymentRequest(
        amount: 25000,
        currency: 'UAH',
        description: 'Another payment',
      );
      await repository.createPaymentToken(request);

      final result = await repository.verifyPayment('txn_67890');

      expect(result.amount, equals(25000));
    });

    test('createPaymentToken simulates network delay', () async {
      const request = CreatePaymentRequest(
        amount: 10000,
        currency: 'UAH',
        description: 'Quick payment',
      );

      final stopwatch = Stopwatch()..start();
      await repository.createPaymentToken(request);
      stopwatch.stop();

      // Should take at least 300ms (the mock delay)
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(250));
    });

    test('verifyPayment simulates network delay', () async {
      const request = CreatePaymentRequest(
        amount: 10000,
        currency: 'UAH',
        description: 'Quick payment',
      );
      await repository.createPaymentToken(request);

      final stopwatch = Stopwatch()..start();
      await repository.verifyPayment('txn_123');
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(250));
    });
  });
}
