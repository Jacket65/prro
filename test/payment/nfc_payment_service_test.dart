import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/api_exception.dart';
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
  setUpAll(() {
    registerFallbackValue(
      const CreatePaymentRequest(amount: 0, currency: '', description: ''),
    );
  });

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

      when(() => mockDeepLinkService.dispose()).thenAnswer((_) async {});
      when(() => mockDeepLinkService.init()).thenAnswer((_) async {});

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

      // Use a StreamController so the correlated callback can be emitted only
      // after the session is established.
      final controller = StreamController<Uri>.broadcast();
      when(() => mockDeepLinkService.onDeepLink).thenAnswer(
        (_) => controller.stream,
      );
      when(() => mockRepository.verifyPayment('txn_12345')).thenAnswer(
        (_) async => result,
      );

      final paymentFuture = service.startPayment(request);

      // Let the session establish (session id set, token created, subscription
      // ready) before emitting the correlated callback.
      await Future<void>.delayed(Duration.zero);
      final sessionId = service.activeSessionId;
      expect(sessionId, isNotNull);

      controller.add(
        Uri.parse(
          'prro://payment?transaction_id=txn_12345&status=SUCCESS'
          '&orderId=$sessionId',
        ),
      );

      final paymentResult = await paymentFuture;

      expect(paymentResult.success, isTrue);
      expect(paymentResult.status, equals('SUCCESS'));
      expect(paymentResult.transactionId, equals('txn_12345'));
      verify(() => mockRepository.createPaymentToken(request)).called(1);
      verify(
        () => mockTerminalLauncher.launchTerminal(
          jwtToken: token.token,
          amount: request.amount,
          currency: request.currency,
          orderId: any<String>(named: 'orderId'),
          merchantId: request.metadata?['merchantId']?.toString(),
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
        ).thenThrow(
          const TerminalLaunchException('Terminal not available'),
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
          (_) => const Stream.empty(),
        );

        // Create service with short timeout for testing
        final testService = NfcPaymentService(
          paymentRepository: mockRepository,
          terminalLauncher: mockTerminalLauncher,
          deepLinkService: mockDeepLinkService,
          talker: mockTalker,
        )..paymentTimeout = const Duration(milliseconds: 100);

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
      'startPayment throws PaymentCancelledException '
      'when terminal reports cancellation',
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
            jwtToken: any<String>(named: 'jwtToken'),
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer(
          (_) async => true,
        );
        // A terminal callback always echoes the orderId we launched with; the
        // (secure) session-correlation check rejects any callback lacking or
        // mismatching it before the status is inspected.
        final controller = StreamController<Uri>();
        when(
          () => mockDeepLinkService.onDeepLink,
        ).thenAnswer((_) => controller.stream);

        final paymentFuture = service.startPayment(request);
        await Future<void>.delayed(Duration.zero);
        final sessionId = service.activeSessionId;
        expect(sessionId, isNotNull);

        controller.add(
          Uri.parse('prro://payment?status=CANCELLED&orderId=$sessionId'),
        );

        await expectLater(
          paymentFuture,
          throwsA(isA<PaymentCancelledException>()),
        ).timeout(const Duration(seconds: 2));
        await controller.close();
      },
    );

    test(
      'startPayment throws PaymentTerminalFailureException '
      'when terminal reports an error without a transaction id',
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
            jwtToken: any<String>(named: 'jwtToken'),
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer(
          (_) async => true,
        );
        final controller = StreamController<Uri>();
        when(
          () => mockDeepLinkService.onDeepLink,
        ).thenAnswer((_) => controller.stream);

        final paymentFuture = service.startPayment(request);
        await Future<void>.delayed(Duration.zero);
        final sessionId = service.activeSessionId;
        expect(sessionId, isNotNull);

        controller.add(
          Uri.parse('prro://payment?status=ERROR&orderId=$sessionId'),
        );

        await expectLater(
          paymentFuture,
          throwsA(isA<PaymentTerminalFailureException>()),
        ).timeout(const Duration(seconds: 2));
        await controller.close();
      },
    );

    test(
      'startPayment throws PaymentTerminalFailureException '
      'when terminal reports a declined payment',
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
            jwtToken: any<String>(named: 'jwtToken'),
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer(
          (_) async => true,
        );
        final controller = StreamController<Uri>();
        when(
          () => mockDeepLinkService.onDeepLink,
        ).thenAnswer((_) => controller.stream);

        final paymentFuture = service.startPayment(request);
        await Future<void>.delayed(Duration.zero);
        final sessionId = service.activeSessionId;
        expect(sessionId, isNotNull);

        controller.add(
          Uri.parse(
            'prro://payment?transaction_id=txn_12345&status=DECLINED'
            '&orderId=$sessionId',
          ),
        );

        await expectLater(
          paymentFuture,
          throwsA(isA<PaymentTerminalFailureException>()),
        ).timeout(const Duration(seconds: 2));
        await controller.close();
      },
    );

    test(
      'startPayment throws InvalidCallbackException '
      'when transactionId format is invalid',
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
            Uri.parse('prro://payment?transaction_id=ab'),
          ]),
        );

        expect(
          () => service.startPayment(request),
          throwsA(isA<InvalidCallbackException>()),
        );
      },
    );

    test(
      'startPayment throws InvalidCallbackException '
      'when callback status is unknown',
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
            Uri.parse(
              'prro://payment?status=whatever&transaction_id=txn_12345',
            ),
          ]),
        );

        expect(
          () => service.startPayment(request),
          throwsA(isA<InvalidCallbackException>()),
        );
      },
    );

    test(
      'startPayment throws InvalidCallbackException '
      'when callback orderId does not match the active session',
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

        final controller = StreamController<Uri>();
        when(() => mockDeepLinkService.onDeepLink).thenAnswer(
          (_) => controller.stream,
        );
        when(() => mockRepository.verifyPayment(any<String>())).thenAnswer(
          (_) async => result,
        );

        final paymentFuture = service.startPayment(request);
        await Future<void>.delayed(Duration.zero);
        final sessionId = service.activeSessionId;
        expect(sessionId, isNotNull);

        // A callback echoing a different (stale) orderId must be rejected.
        controller.add(
          Uri.parse(
            'prro://payment?transaction_id=txn_12345&status=SUCCESS'
            '&orderId=stale_session_id',
          ),
        );

        expect(
          paymentFuture,
          throwsA(isA<InvalidCallbackException>()),
        );
      },
    );

    test(
      'startPayment disposes the DeepLinkService when the payment ends',
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

        final controller = StreamController<Uri>();
        when(() => mockDeepLinkService.onDeepLink).thenAnswer(
          (_) => controller.stream,
        );
        when(() => mockRepository.verifyPayment('txn_12345')).thenAnswer(
          (_) async => result,
        );

        final paymentFuture = service.startPayment(request);
        await Future<void>.delayed(Duration.zero);
        final sessionId = service.activeSessionId;
        expect(sessionId, isNotNull);

        controller.add(
          Uri.parse(
            'prro://payment?transaction_id=txn_12345&status=SUCCESS'
            '&orderId=$sessionId',
          ),
        );

        await paymentFuture;

        verify(() => mockDeepLinkService.dispose()).called(1);
        expect(service.activeSessionId, isNull);
      },
    );

    test(
      'startPayment throws PaymentAlreadyInProgressException '
      'when called while another session is active',
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

        // Keep the first call active by never resolving its token creation.
        final tokenCompleter = Completer<TerminalToken>();
        when(() => mockRepository.createPaymentToken(any())).thenAnswer(
          (_) => tokenCompleter.future,
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
          (_) => const Stream.empty(),
        );

        // A short timeout lets the (released) first call terminate quickly.
        service.paymentTimeout = const Duration(milliseconds: 100);
        final first = service.startPayment(request);
        await Future<void>.delayed(Duration.zero);
        expect(service.activeSessionId, isNotNull);

        // The second concurrent call must be rejected by the guard.
        expect(
          () => service.startPayment(request),
          throwsA(isA<PaymentAlreadyInProgressException>()),
        );

        // Release the first call and let it time out so nothing leaks.
        tokenCompleter.complete(token);
        await expectLater(
          first,
          throwsA(isA<PaymentCallbackTimeoutException>()),
        ).timeout(const Duration(seconds: 2));
      },
    );

    group('cancelPayment', () {
      test(
        'completes the in-flight startPayment with PaymentCancelledException',
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
            (_) => const Stream.empty(),
          );

          final future = service.startPayment(request);
          await Future<void>.delayed(Duration.zero);
          expect(service.activeSessionId, isNotNull);

          service.cancelPayment();

          await expectLater(
            future,
            throwsA(isA<PaymentCancelledException>()),
          ).timeout(const Duration(seconds: 2));

          // Cleanup ran: the session guard was cleared and the deep link
          // service was torn down.
          expect(service.activeSessionId, isNull);
          verify(() => mockDeepLinkService.dispose()).called(1);
        },
      );

      test('a second startPayment succeeds after a cancellation', () async {
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
        when(() => mockRepository.verifyPayment(any<String>())).thenAnswer(
          (_) async => result,
        );

        final controller = StreamController<Uri>.broadcast();
        when(() => mockDeepLinkService.onDeepLink).thenAnswer(
          (_) => controller.stream,
        );

        var future = service.startPayment(request);
        await Future<void>.delayed(Duration.zero);
        service.cancelPayment();
        await expectLater(
          future,
          throwsA(isA<PaymentCancelledException>()),
        ).timeout(const Duration(seconds: 2));

        // The single-active guard must have reset so a new attempt can start.
        future = service.startPayment(request);
        await Future<void>.delayed(Duration.zero);
        final sessionId = service.activeSessionId;
        expect(sessionId, isNotNull);

        controller.add(
          Uri.parse(
            'prro://payment?transaction_id=txn_12345&status=SUCCESS'
            '&orderId=$sessionId',
          ),
        );

        final paymentResult = await future;
        expect(paymentResult.success, isTrue);
        await controller.close();
      });

      test(
        'repeated cancelPayment is harmless (no double-complete error)',
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
            (_) => const Stream.empty(),
          );

          final future = service.startPayment(request);
          await Future<void>.delayed(Duration.zero);
          service.cancelPayment();
          await expectLater(
            future,
            throwsA(isA<PaymentCancelledException>()),
          ).timeout(const Duration(seconds: 2));

          // A second cancel after the session ended must be a no-op.
          expect(() => service.cancelPayment(), returnsNormally);
        },
      );

      test(
        'cancel during token creation aborts before launching the terminal',
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

          // Fire the cancel from inside token creation, before the terminal is
          // launched.
          when(() => mockRepository.createPaymentToken(request)).thenAnswer(
            (_) async {
              service.cancelPayment();
              return token;
            },
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
            (_) => const Stream.empty(),
          );

          await expectLater(
            () => service.startPayment(request),
            throwsA(isA<PaymentCancelledException>()),
          ).timeout(const Duration(seconds: 2));

          // The terminal must never have been launched for a cancelled session.
          verifyNever(
            () => mockTerminalLauncher.launchTerminal(
              jwtToken: any<String>(named: 'jwtToken'),
              amount: any<int>(named: 'amount'),
              currency: any<String>(named: 'currency'),
              orderId: any<String>(named: 'orderId'),
              merchantId: any<String?>(named: 'merchantId'),
            ),
          );
        },
      );
    });

    group('callback and cancellation races', () {
      CreatePaymentRequest req() => const CreatePaymentRequest(
        amount: 15000,
        currency: 'UAH',
        description: 'Test payment',
        orderId: 'test_order',
      );

      TerminalToken token() => TerminalToken(
        token: 'test_jwt_token',
        expiresAt: DateTime.now().add(const Duration(minutes: 10)),
      );

      PaymentResult okResult() => const PaymentResult(
        success: true,
        status: 'SUCCESS',
        rrn: '123456789012',
        amount: 15000,
        transactionId: 'txn_12345',
        cardMask: '5168 **** **** 1234',
        authCode: '123456',
      );

      Uri successUri(String sessionId) => Uri.parse(
        'prro://payment?transaction_id=txn_12345&status=SUCCESS'
        '&orderId=$sessionId',
      );

      Future<void> stubCommon() async {
        when(
          () => mockRepository.createPaymentToken(any()),
        ).thenAnswer((_) async => token());
        when(
          () => mockTerminalLauncher.launchTerminal(
            jwtToken: any<String>(named: 'jwtToken'),
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer((_) async => true);
        when(
          () => mockRepository.verifyPayment(any()),
        ).thenAnswer((_) async => okResult());
      }

      test(
        'early callback (before launch resolves) still succeeds once',
        () async {
          await stubCommon();
          final controller = StreamController<Uri>.broadcast();
          when(
            () => mockDeepLinkService.onDeepLink,
          ).thenAnswer((_) => controller.stream);

          final future = service.startPayment(req());
          await Future<void>.delayed(Duration.zero);
          final sessionId = service.activeSessionId;
          expect(sessionId, isNotNull);

          // Callback fires immediately, while launchTerminal is still awaiting.
          controller.add(successUri(sessionId!));

          final result = await future;
          expect(result.success, isTrue);
          verify(
            () => mockTerminalLauncher.launchTerminal(
              jwtToken: any<String>(named: 'jwtToken'),
              amount: any<int>(named: 'amount'),
              currency: any<String>(named: 'currency'),
              orderId: any<String>(named: 'orderId'),
              merchantId: any<String?>(named: 'merchantId'),
            ),
          ).called(1);
          verify(() => mockRepository.verifyPayment('txn_12345')).called(1);
          await controller.close();
        },
      );

      test('callback after timeout is ignored (no verification)', () async {
        await stubCommon();
        final testService = NfcPaymentService(
          paymentRepository: mockRepository,
          terminalLauncher: mockTerminalLauncher,
          deepLinkService: mockDeepLinkService,
          talker: mockTalker,
        )..paymentTimeout = const Duration(milliseconds: 80);

        final controller = StreamController<Uri>.broadcast();
        when(
          () => mockDeepLinkService.onDeepLink,
        ).thenAnswer((_) => controller.stream);

        final future = testService.startPayment(req());
        // Attach the expectation before the future can complete so the error
        // is always observed by a listener (the real caller awaits it too).
        final expectation = expectLater(
          future,
          throwsA(isA<PaymentCallbackTimeoutException>()),
        );
        await Future<void>.delayed(Duration.zero);
        // Let the timeout fire.
        await Future<void>.delayed(const Duration(milliseconds: 150));

        // A late callback must be ignored — the completer already resolved.
        controller.add(
          Uri.parse(
            'prro://payment?transaction_id=txn_12345&status=SUCCESS'
            '&orderId=stale',
          ),
        );

        await expectation.timeout(const Duration(seconds: 2));
        verifyNever(() => mockRepository.verifyPayment(any()));
        await controller.close();
      });

      test(
        'duplicate callback resolves exactly once (no double verify)',
        () async {
          await stubCommon();
          final controller = StreamController<Uri>.broadcast();
          when(
            () => mockDeepLinkService.onDeepLink,
          ).thenAnswer((_) => controller.stream);

          final future = service.startPayment(req());
          await Future<void>.delayed(Duration.zero);
          final sessionId = service.activeSessionId;
          expect(sessionId, isNotNull);

          final uri = successUri(sessionId!);
          controller
            ..add(uri)
            ..add(uri);

          final result = await future;
          expect(result.success, isTrue);
          verify(() => mockRepository.verifyPayment('txn_12345')).called(1);
          await controller.close();
        },
      );

      test('callback after cancellation is ignored', () async {
        await stubCommon();
        final controller = StreamController<Uri>.broadcast();
        when(
          () => mockDeepLinkService.onDeepLink,
        ).thenAnswer((_) => controller.stream);

        final future = service.startPayment(req());
        // Attach the expectation before the future can complete so the error
        // is always observed by a listener (the real caller awaits it too).
        final expectation = expectLater(
          future,
          throwsA(isA<PaymentCancelledException>()),
        );
        await Future<void>.delayed(Duration.zero);
        service.cancelPayment();
        await Future<void>.delayed(Duration.zero);

        // Late callback must not resurrect a cancelled payment.
        controller.add(
          Uri.parse(
            'prro://payment?transaction_id=txn_12345&status=SUCCESS'
            '&orderId=whatever',
          ),
        );

        await expectation.timeout(const Duration(seconds: 2));
        verifyNever(() => mockRepository.verifyPayment(any()));
        await controller.close();
      });

      test('cancellation during launch aborts before verification', () async {
        await stubCommon();
        // Make launchTerminal hang so we can cancel mid-launch.
        final launchCompleter = Completer<void>();
        when(
          () => mockTerminalLauncher.launchTerminal(
            jwtToken: any<String>(named: 'jwtToken'),
            amount: any<int>(named: 'amount'),
            currency: any<String>(named: 'currency'),
            orderId: any<String>(named: 'orderId'),
            merchantId: any<String?>(named: 'merchantId'),
          ),
        ).thenAnswer((_) => launchCompleter.future);

        final controller = StreamController<Uri>.broadcast();
        when(
          () => mockDeepLinkService.onDeepLink,
        ).thenAnswer((_) => controller.stream);

        final future = service.startPayment(req());
        await Future<void>.delayed(Duration.zero);
        service.cancelPayment();
        launchCompleter.complete();

        await expectLater(
          future,
          throwsA(isA<PaymentCancelledException>()),
        ).timeout(const Duration(seconds: 2));
        verifyNever(() => mockRepository.verifyPayment(any()));
        await controller.close();
      });

      test(
        'deep-link stream error maps to PaymentOperationException',
        () async {
          await stubCommon();
          final controller = StreamController<Uri>();
          when(
            () => mockDeepLinkService.onDeepLink,
          ).thenAnswer((_) => controller.stream);

          final future = service.startPayment(req());
          await Future<void>.delayed(Duration.zero);
          controller.addError(Exception('deep link transport broke'));

          await expectLater(
            future,
            throwsA(isA<PaymentOperationException>()),
          ).timeout(const Duration(seconds: 2));
          await controller.close();
        },
      );

      test(
        'repository token failure maps to PaymentOperationException',
        () async {
          when(
            () => mockRepository.createPaymentToken(any()),
          ).thenThrow(const ApiException('token creation failed'));
          when(
            () => mockTerminalLauncher.launchTerminal(
              jwtToken: any<String>(named: 'jwtToken'),
              amount: any<int>(named: 'amount'),
              currency: any<String>(named: 'currency'),
              orderId: any<String>(named: 'orderId'),
              merchantId: any<String?>(named: 'merchantId'),
            ),
          ).thenAnswer((_) async => true);
          when(
            () => mockDeepLinkService.onDeepLink,
          ).thenAnswer((_) => const Stream.empty());

          await expectLater(
            () => service.startPayment(req()),
            throwsA(isA<PaymentOperationException>()),
          ).timeout(const Duration(seconds: 2));
        },
      );

      test(
        'repository verification failure maps to PaymentOperationException',
        () async {
          await stubCommon();
          when(
            () => mockRepository.verifyPayment(any()),
          ).thenThrow(const ApiException('verify failed'));
          final controller = StreamController<Uri>.broadcast();
          when(
            () => mockDeepLinkService.onDeepLink,
          ).thenAnswer((_) => controller.stream);

          final future = service.startPayment(req());
          await Future<void>.delayed(Duration.zero);
          final sessionId = service.activeSessionId;
          controller.add(successUri(sessionId!));

          await expectLater(
            future,
            throwsA(isA<PaymentOperationException>()),
          ).timeout(const Duration(seconds: 2));
          await controller.close();
        },
      );
    });
  });
}
