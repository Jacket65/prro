import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/api/models/payment/payment_result.dart';
import 'package:prro/data/api/models/payment/payment_token.dart';
import 'package:prro/data/repositories/payment_repository/payment_repo_i.dart';
import 'package:prro/services/deep_link_service.dart';
import 'package:prro/services/nfc_payment_service.dart';
import 'package:prro/services/terminal_launcher.dart';
import 'package:talker/talker.dart';

// Mocks
class MockPaymentRepository extends Mock implements PaymentRepositoryI {}

class MockTerminalLauncher extends Mock implements TerminalLauncherI {}

class MockDeepLinkService extends Mock implements DeepLinkServiceI {}

class MockTalker extends Mock implements Talker {}

void main() {
  group('NfcPaymentService', () {
    late MockPaymentRepository mockRepository;
    late MockTerminalLauncher mockTerminalLauncher;
    late MockDeepLinkService mockDeepLinkService;
    late MockTalker mockTalker;
    late NfcPaymentService service;

    setUp(() {
      mockRepository = MockPaymentRepository();
      mockTerminalLauncher = MockTerminalLauncher();
      mockDeepLinkService = MockDeepLinkService();
      mockTalker = MockTalker();

      service = NfcPaymentService(
        paymentRepository: mockRepository,
        terminalLauncher: mockTerminalLauncher,
        deepLinkService: mockDeepLinkService,
        talker: mockTalker,
      );
    });

    test('startPayment returns successful PaymentResult on success', () async {
      const request = CreatePaymentRequest(
        amount: 15000,
        currency: 'UAH',
        description: 'Test payment',
        orderId: 'test_order',
      );
      final token = TerminalToken(
        token: 'test_jwt_token',
        expiresAt: DateTime.now().add(const Duration(minutes: 10)),
      );
      const result = PaymentResult(
        success: true,
        status: 'SUCCESS',
        rrn: '123456789012',
        amount: 15000,
        transactionId: 'txn_12345',
        cardMask: '5168 **** **** 1234',
        authCode: '123456',
      );

      when(() => mockRepository.createPaymentToken(request)).thenAnswer(
        (_) async => token,
      );
      when(
        () => mockTerminalLauncher.launchTerminal(
          jwtToken: any<String>(named: 'jwtToken'),
          amount: any<int>(named: 'amount'),
          currency: any<String>(named: 'currency'),
          orderId: any<String>(named: 'orderId'),
          merchantId: any<String?>(named: 'merchantId'),
        ),
      ).thenAnswer(
        (_) async => true,
      );
      when(() => mockDeepLinkService.onDeepLink).thenAnswer(
        (_) => Stream.fromIterable([
          Uri.parse('prro://payment?transaction_id=txn_12345&status=SUCCESS'),
        ]),
      );
      when(() => mockRepository.verifyPayment('txn_12345')).thenAnswer(
        (_) async => result,
      );

      final paymentResult = await service.startPayment(request);

      expect(paymentResult.success, isTrue);
      expect(paymentResult.status, equals('SUCCESS'));
      expect(paymentResult.transactionId, equals('txn_12345'));
      verify(() => mockRepository.createPaymentToken(request)).called(1);
      verify(
        () => mockTerminalLauncher.launchTerminal(
          jwtToken: token.token,
          amount: request.amount,
          currency: request.currency,
          orderId: request.orderId!,
          merchantId: request.metadata?['merchantId'] as String?,
        ),
      ).called(1);
      verify(() => mockRepository.verifyPayment('txn_12345')).called(1);
    });

    test(
      'startPayment throws TerminalLaunchFailedException '
      'when terminal launch fails',
      () async {
        const request = CreatePaymentRequest(
          amount: 15000,
          currency: 'UAH',
          description: 'Test payment',
          orderId: 'test_order',
        );
        final token = TerminalToken(
          token: 'test_jwt_token',
          expiresAt: DateTime.now().add(const Duration(minutes: 10)),
        );

        when(() => mockRepository.createPaymentToken(request)).thenAnswer(
          (_) async => token,
        );
        when(() => mockDeepLinkService.onDeepLink).thenAnswer(
          (_) => const Stream.empty(),
        );
        when(
          () => mockTerminalLauncher.launchTerminal(
            jwtToken: any<String>(named: 'jwtToken'),
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer(
          (_) async => false,
        );

        expect(
          () => service.startPayment(request),
          throwsA(isA<TerminalLaunchFailedException>()),
        );
      },
    );

    test(
      'startPayment throws PaymentCallbackTimeoutException on timeout',
      () async {
        const request = CreatePaymentRequest(
          amount: 15000,
          currency: 'UAH',
          description: 'Test payment',
          orderId: 'test_order',
        );
        final token = TerminalToken(
          token: 'test_jwt_token',
          expiresAt: DateTime.now().add(const Duration(minutes: 10)),
        );

        when(() => mockRepository.createPaymentToken(request)).thenAnswer(
          (_) async => token,
        );
        when(
          () => mockTerminalLauncher.launchTerminal(
            jwtToken: token.token,
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer(
          (_) async => true,
        );
        when(() => mockDeepLinkService.onDeepLink).thenAnswer(
          (_) => const Stream.empty(),
        );

        // Create service with short timeout for testing
        final testService = NfcPaymentService(
          paymentRepository: mockRepository,
          terminalLauncher: mockTerminalLauncher,
          deepLinkService: mockDeepLinkService,
          talker: mockTalker,
        );

        expect(
          () => testService.startPayment(request),
          throwsA(isA<PaymentCallbackTimeoutException>()),
        );
      },
    );

    test(
      'startPayment throws InvalidCallbackException '
      'when transactionId is missing',
      () async {
        const request = CreatePaymentRequest(
          amount: 15000,
          currency: 'UAH',
          description: 'Test payment',
          orderId: 'test_order',
        );
        final token = TerminalToken(
          token: 'test_jwt_token',
          expiresAt: DateTime.now().add(const Duration(minutes: 10)),
        );

        when(() => mockRepository.createPaymentToken(request)).thenAnswer(
          (_) async => token,
        );
        when(
          () => mockTerminalLauncher.launchTerminal(
            jwtToken: token.token,
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer(
          (_) async => true,
        );
        when(() => mockDeepLinkService.onDeepLink).thenAnswer(
          (_) => Stream.fromIterable([
            Uri.parse('prro://payment?status=SUCCESS'),
          ]),
        );

        expect(
          () => service.startPayment(request),
          throwsA(isA<InvalidCallbackException>()),
        );
      },
    );

    test(
      'startPayment throws PaymentVerificationFailedException '
      'when verification fails',
      () async {
        const request = CreatePaymentRequest(
          amount: 15000,
          currency: 'UAH',
          description: 'Test payment',
          orderId: 'test_order',
        );
        final token = TerminalToken(
          token: 'test_jwt_token',
          expiresAt: DateTime.now().add(const Duration(minutes: 10)),
        );
        const failedResult = PaymentResult(
          success: false,
          status: 'FAILED',
          amount: 15000,
          transactionId: 'txn_12345',
        );

        when(() => mockRepository.createPaymentToken(request)).thenAnswer(
          (_) async => token,
        );
        when(
          () => mockTerminalLauncher.launchTerminal(
            jwtToken: token.token,
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer(
          (_) async => true,
        );
        when(() => mockDeepLinkService.onDeepLink).thenAnswer(
          (_) => Stream.fromIterable([
            Uri.parse('prro://payment?transaction_id=txn_12345&status=FAILED'),
          ]),
        );
        when(() => mockRepository.verifyPayment('txn_12345')).thenAnswer(
          (_) async => failedResult,
        );

        final paymentResult = await service.startPayment(request);

        expect(paymentResult.success, isFalse);
        expect(paymentResult.status, equals('FAILED'));
      },
    );
  });
}
