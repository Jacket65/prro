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
      expect(token.token, startsWith('mock_jwt_'));
      expect(token.expiresAt.isAfter(DateTime.now()), isTrue);
      // The mock mints a transaction id and exposes it for verification.
      expect(repository.lastTransactionId, isNotNull);
      expect(repository.lastTransactionId, startsWith('mock_txn_'));
    });

    test('verifyPayment returns a successful PaymentResult', () async {
      const request = CreatePaymentRequest(
        amount: 15000,
        currency: 'UAH',
        description: 'Test payment',
      );
      await repository.createPaymentToken(request);

      final result = await repository.verifyPayment(
        repository.lastTransactionId!,
      );

      expect(result, isA<PaymentResult>());
      expect(result.success, isTrue);
      expect(result.status, equals('SUCCESS'));
      expect(result.amount, equals(15000));
      expect(result.transactionId, equals(repository.lastTransactionId));
      expect(result.cardMask, equals('5168 **** **** 1234'));
      expect(result.authCode, equals('123456'));
      expect(repository.lastResult, equals(result));
    });

    test('verifyPayment uses amount from the created transaction', () async {
      const request = CreatePaymentRequest(
        amount: 25000,
        currency: 'UAH',
        description: 'Another payment',
      );
      await repository.createPaymentToken(request);

      final result = await repository.verifyPayment(
        repository.lastTransactionId!,
      );

      expect(result.amount, equals(25000));
    });

    test(
      'verifyPayment throws PaymentUnknownTransactionException '
      'for an unknown transaction id',
      () async {
        expect(
          () => repository.verifyPayment('unknown_txn_123'),
          throwsA(isA<PaymentUnknownTransactionException>()),
        );
      },
    );

    test(
      'verifyPayment is idempotent: a second verify of the same id throws',
      () async {
        const request = CreatePaymentRequest(
          amount: 15000,
          currency: 'UAH',
          description: 'Test payment',
        );
        await repository.createPaymentToken(request);
        final transactionId = repository.lastTransactionId!;

        final first = await repository.verifyPayment(transactionId);
        expect(first.success, isTrue);

        // The transaction is consumed on first verify, so a duplicate throws.
        expect(
          () => repository.verifyPayment(transactionId),
          throwsA(isA<PaymentUnknownTransactionException>()),
        );
      },
    );

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
      await repository.verifyPayment(repository.lastTransactionId!);
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(250));
    });
  });
}
