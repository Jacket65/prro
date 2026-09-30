import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';
import 'package:prro/features/seller/bloc/orders/payment/handlers/terminal_payment_handler.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';
import 'package:prro/services/terminal_payment_service.dart' as terminal;

class MockTerminalService extends Mock
    implements terminal.TerminalPaymentServiceI {}

class MockOrdersRepository extends Mock implements OrdersRepositoryI {}

OrderReceipt _receipt({String status = 'pending'}) => OrderReceipt(
  orderId: '42',
  lines: [],
  totalKopecks: 15000,
  tenderedKopecks: 15000,
  changeKopecks: 0,
  method: PaymentMethod.terminal,
  status: status,
  issuedAt: DateTime(2024),
  storeName: 'Store',
  cashierName: 'Cashier',
);

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CreatePaymentRequest(amount: 0, currency: '', description: ''),
    );
  });

  late MockTerminalService service;
  late MockOrdersRepository ordersRepository;
  late TerminalPaymentHandler handler;

  setUp(() {
    service = MockTerminalService();
    ordersRepository = MockOrdersRepository();
    handler = TerminalPaymentHandler(service, ordersRepository);

    when(() => ordersRepository.confirmOrder(any())).thenAnswer(
      (_) async => _receipt(status: 'completed'),
    );
  });

  const request = PaymentRequest(
    amountKopecks: 15000,
    tenderedKopecks: 15000,
    currency: 'UAH',
  );

  test('method is terminal', () {
    expect(handler.method, PaymentMethod.terminal);
  });

  test('pay is a no-op (order-first: nothing is charged before the order)', () {
    expect(() => handler.pay(request), returnsNormally);
    verifyNoMoreInteractions(service);
    verifyNoMoreInteractions(ordersRepository);
  });

  group('afterOrderCreated', () {
    test(
      'maps order + request onto CreatePaymentRequest with order_id',
      () async {
        when(() => service.startPayment(any())).thenAnswer(
          (_) async => const PaymentResult(success: true, status: 'SUCCESS'),
        );

        await handler.afterOrderCreated(_receipt(), request);

        final captured =
            verify(() => service.startPayment(captureAny())).captured.single
                as CreatePaymentRequest;
        expect(captured.amount, 15000);
        expect(captured.currency, 'UAH');
        expect(captured.description, 'Order payment');
        expect(captured.orderId, '42');
      },
    );

    test('confirms the order after a successful charge and returns the '
        'confirmed receipt', () async {
      when(() => service.startPayment(any())).thenAnswer(
        (_) async => const PaymentResult(success: true, status: 'SUCCESS'),
      );

      final receipt = await handler.afterOrderCreated(_receipt(), request);

      verify(() => ordersRepository.confirmOrder(42)).called(1);
      expect(receipt.status, 'completed');
    });

    test('falls back to the pending receipt when confirm fails', () async {
      when(() => service.startPayment(any())).thenAnswer(
        (_) async => const PaymentResult(success: true, status: 'SUCCESS'),
      );
      when(() => ordersRepository.confirmOrder(any())).thenThrow(
        Exception('confirm 409'),
      );

      final pending = _receipt();
      final receipt = await handler.afterOrderCreated(pending, request);

      expect(receipt, pending);
    });

    test(
      'falls back to the pending receipt when the order id is not an int',
      () async {
        when(() => service.startPayment(any())).thenAnswer(
          (_) async => const PaymentResult(success: true, status: 'SUCCESS'),
        );

        final pending = OrderReceipt(
          orderId: 'abc-1',
          lines: [],
          totalKopecks: 15000,
          tenderedKopecks: 15000,
          changeKopecks: 0,
          method: PaymentMethod.terminal,
          status: 'pending',
          issuedAt: DateTime(2024),
          storeName: 'Store',
          cashierName: 'Cashier',
        );
        final receipt = await handler.afterOrderCreated(pending, request);

        expect(receipt, pending);
        verifyNever(() => ordersRepository.confirmOrder(any()));
      },
    );

    test('charge failure means confirm is never called', () async {
      when(() => service.startPayment(any())).thenThrow(
        const terminal.PaymentTerminalFailureException('declined'),
      );

      await expectLater(
        () => handler.afterOrderCreated(_receipt(), request),
        throwsA(isA<PaymentException>()),
      );
      verifyNever(() => ordersRepository.confirmOrder(any()));
    });

    test('result.success == false throws PaymentException', () async {
      when(() => service.startPayment(any())).thenAnswer(
        (_) async => const PaymentResult(success: false, status: 'FAILED'),
      );
      await expectLater(
        () => handler.afterOrderCreated(_receipt(), request),
        throwsA(
          isA<PaymentException>().having(
            (e) => e.message,
            'message',
            'Оплата не пройшла: FAILED',
          ),
        ),
      );
      verifyNever(() => ordersRepository.confirmOrder(any()));
    });
  });

  group('terminal exceptions map to PaymentException', () {
    Future<void> expectMapped(Object ex) async {
      when(() => service.startPayment(any())).thenThrow(ex);
      await expectLater(
        () => handler.afterOrderCreated(_receipt(), request),
        throwsA(
          isA<PaymentException>().having(
            (e) => e.message,
            'message',
            (ex as dynamic).message as String,
          ),
        ),
      );
    }

    test('TerminalLaunchFailedException', () async {
      await expectMapped(
        const terminal.TerminalLaunchFailedException('launch failed'),
      );
    });

    test('PaymentTerminalFailureException', () async {
      await expectMapped(
        const terminal.PaymentTerminalFailureException('terminal error'),
      );
    });

    test('PaymentCallbackTimeoutException', () async {
      await expectMapped(
        const terminal.PaymentCallbackTimeoutException('timed out'),
      );
    });

    test('InvalidCallbackException', () async {
      await expectMapped(
        const terminal.InvalidCallbackException('bad callback'),
      );
    });

    test('PaymentAlreadyInProgressException', () async {
      await expectMapped(
        const terminal.PaymentAlreadyInProgressException('in progress'),
      );
    });
  });

  test(
    'terminal PaymentCancelledException maps to app PaymentCancelledException',
    () async {
      when(() => service.startPayment(any())).thenThrow(
        const terminal.PaymentCancelledException('cancelled at terminal'),
      );
      await expectLater(
        () => handler.afterOrderCreated(_receipt(), request),
        throwsA(isA<PaymentCancelledException>()),
      );
      verifyNever(() => ordersRepository.confirmOrder(any()));
    },
  );

  test('cancel delegates to the service cancelPayment', () {
    when(() => service.cancelPayment()).thenReturn(null);
    handler.cancel();
    verify(() => service.cancelPayment()).called(1);
  });
}
