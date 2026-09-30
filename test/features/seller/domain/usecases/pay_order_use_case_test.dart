import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/payment/domain/payment_exceptions.dart';
import 'package:prro/features/seller/domain/payment/handlers/cash_payment_handler.dart';
import 'package:prro/features/seller/domain/payment/handlers/terminal_payment_handler.dart';
import 'package:prro/features/seller/domain/payment/pay_order_request.dart';
import 'package:prro/features/seller/domain/payment/payment_method_handler.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/usecases/pay_order_use_case.dart';

class MockCashHandler extends Mock implements CashPaymentHandler {}

class MockTerminalHandler extends Mock implements TerminalPaymentHandler {}

class MockOrdersRepository extends Mock implements OrdersRepositoryI {}

OrderReceipt _receipt({String status = 'pending'}) => OrderReceipt(
  orderId: '1',
  lines: [],
  totalKopecks: 100,
  tenderedKopecks: 100,
  changeKopecks: 0,
  method: PaymentMethod.cash,
  status: status,
  issuedAt: DateTime(2024),
  storeName: 'Store',
  cashierName: 'Cashier',
);

void main() {
  setUpAll(() {
    registerFallbackValue(PaymentMethod.cash);
    registerFallbackValue(
      const PaymentRequest(
        amountKopecks: 0,
        tenderedKopecks: 0,
        currency: 'UAH',
      ),
    );
    registerFallbackValue(_receipt());
    registerFallbackValue(
      const PayOrderRequest(
        method: PaymentMethod.cash,
        tenderedKopecks: 0,
        idempotencyKey: 'k',
      ),
    );
  });

  late MockCashHandler cash;
  late MockTerminalHandler terminal;
  late MockOrdersRepository repo;
  late PayOrderUseCase useCase;

  setUp(() {
    cash = MockCashHandler();
    terminal = MockTerminalHandler();
    repo = MockOrdersRepository();

    when(() => cash.method).thenReturn(PaymentMethod.cash);
    when(() => terminal.method).thenReturn(PaymentMethod.terminal);
    when(() => cash.pay(any())).thenAnswer((_) async {});
    when(() => terminal.pay(any())).thenAnswer((_) async {});
    when(() => cash.cancel()).thenReturn(null);
    when(() => terminal.cancel()).thenReturn(null);
    // Cash: afterOrderCreated is identity — returns the placed receipt.
    when(() => cash.afterOrderCreated(any(), any())).thenAnswer(
      (inv) async => inv.positionalArguments[0] as OrderReceipt,
    );
    // Terminal: afterOrderCreated returns the confirmed receipt.
    when(() => terminal.afterOrderCreated(any(), any())).thenAnswer(
      (_) async => _receipt(status: 'completed'),
    );
    when(
      () => repo.placeOrder(
        method: any(named: 'method'),
        tenderedKopecks: any(named: 'tenderedKopecks'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => _receipt());
    when(() => repo.totalPrice).thenReturn(50);

    useCase = PayOrderUseCase(
      ordersRepository: repo,
      cash: cash,
      terminal: terminal,
    );
  });

  PayOrderRequest req(PaymentMethod m) => PayOrderRequest(
    method: m,
    tenderedKopecks: 100,
    idempotencyKey: 'key',
  );

  group('handler selection', () {
    test('cash request uses the cash handler only', () async {
      await useCase(req(PaymentMethod.cash));
      verify(() => cash.pay(any())).called(1);
      verifyNever(() => terminal.pay(any()));
    });

    test('terminal request uses the terminal handler only', () async {
      await useCase(req(PaymentMethod.terminal));
      verify(() => terminal.pay(any())).called(1);
      verifyNever(() => cash.pay(any()));
    });
  });

  group('sequence: pay → placeOrder → afterOrderCreated', () {
    test('cash path: pay, placeOrder, then afterOrderCreated with the placed '
        'receipt; the placed receipt is returned', () async {
      when(() => cash.afterOrderCreated(any(), any())).thenAnswer((inv) async {
        // placeOrder must have happened before the finalize hook runs.
        verify(
          () => repo.placeOrder(
            method: any(named: 'method'),
            tenderedKopecks: any(named: 'tenderedKopecks'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).called(1);
        return inv.positionalArguments[0] as OrderReceipt;
      });

      final receipt = await useCase(req(PaymentMethod.cash));

      final captured = verify(
        () => cash.afterOrderCreated(captureAny(), any()),
      ).captured.single;
      expect(captured, isA<OrderReceipt>());
      expect(receipt.status, 'pending'); // the placed (identical) receipt
      verify(() => cash.pay(any())).called(1);
    });

    test('terminal path: placeOrder runs BEFORE the charge hook, and the '
        'confirmed receipt is returned', () async {
      when(() => terminal.afterOrderCreated(any(), any())).thenAnswer((_) {
        // The order must exist server-side before the terminal charges.
        verify(
          () => repo.placeOrder(
            method: any(named: 'method'),
            tenderedKopecks: any(named: 'tenderedKopecks'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).called(1);
        return Future.value(_receipt(status: 'completed'));
      });

      final receipt = await useCase(req(PaymentMethod.terminal));

      expect(receipt.status, 'completed');
      final captured = verify(
        () => terminal.afterOrderCreated(captureAny(), captureAny()),
      ).captured;
      final order = captured[0] as OrderReceipt;
      final paymentRequest = captured[1] as PaymentRequest;
      expect(order.orderId, '1'); // receipt from placeOrder
      expect(paymentRequest.amountKopecks, 5000); // uahToKopecks(totalPrice)
      expect(paymentRequest.tenderedKopecks, 100);
      expect(paymentRequest.currency, 'UAH');
    });

    test('pay is called with amount derived from totalPrice', () async {
      await useCase(req(PaymentMethod.cash));
      final captured =
          verify(() => cash.pay(captureAny())).captured.single
              as PaymentRequest;
      expect(captured.amountKopecks, 5000); // uahToKopecks(50.0)
      expect(captured.tenderedKopecks, 100);
      expect(captured.currency, 'UAH');
    });

    test('placeOrder is called only after successful pay', () async {
      await useCase(req(PaymentMethod.cash));
      verify(
        () => repo.placeOrder(
          method: PaymentMethod.cash,
          tenderedKopecks: 100,
          idempotencyKey: 'key',
        ),
      ).called(1);
    });

    test('placeOrder is NOT called when pay fails', () async {
      when(() => cash.pay(any())).thenThrow(const PaymentException('nope'));
      await expectLater(
        () => useCase(req(PaymentMethod.cash)),
        throwsA(isA<PaymentException>()),
      );
      verifyNever(
        () => repo.placeOrder(
          method: any(named: 'method'),
          tenderedKopecks: any(named: 'tenderedKopecks'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
    });

    test('placeOrder is NOT called when pay cancels', () async {
      when(() => cash.pay(any())).thenThrow(const PaymentCancelledException());
      await expectLater(
        () => useCase(req(PaymentMethod.cash)),
        throwsA(isA<PaymentCancelledException>()),
      );
      verifyNever(
        () => repo.placeOrder(
          method: any(named: 'method'),
          tenderedKopecks: any(named: 'tenderedKopecks'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
    });

    test('afterOrderCreated is NOT called when placeOrder fails', () async {
      when(
        () => repo.placeOrder(
          method: any(named: 'method'),
          tenderedKopecks: any(named: 'tenderedKopecks'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(const ApiException('store closed'));
      await expectLater(
        () => useCase(req(PaymentMethod.terminal)),
        throwsA(
          isA<PaymentException>().having(
            (e) => e.reason,
            'reason',
            PaymentFailureReason.verificationFailed,
          ),
        ),
      );
      verifyNever(() => terminal.afterOrderCreated(any(), any()));
    });
  });

  group('afterOrderCreated failures', () {
    test('PaymentException propagates unchanged', () async {
      when(() => terminal.afterOrderCreated(any(), any())).thenThrow(
        const PaymentException(
          'charge failed',
          reason: PaymentFailureReason.terminalDeclined,
        ),
      );
      await expectLater(
        () => useCase(req(PaymentMethod.terminal)),
        throwsA(
          isA<PaymentException>().having(
            (e) => e.reason,
            'reason',
            PaymentFailureReason.terminalDeclined,
          ),
        ),
      );
    });

    test('cancel during the terminal charge propagates '
        'PaymentCancelledException', () async {
      when(() => terminal.afterOrderCreated(any(), any())).thenThrow(
        const PaymentCancelledException(),
      );
      await expectLater(
        () => useCase(req(PaymentMethod.terminal)),
        throwsA(isA<PaymentCancelledException>()),
      );
    });

    test(
      'unexpected errors are wrapped into PaymentException (boundary)',
      () async {
        when(() => terminal.afterOrderCreated(any(), any())).thenThrow(
          StateError('boom'),
        );
        await expectLater(
          () => useCase(req(PaymentMethod.terminal)),
          throwsA(
            isA<PaymentException>().having(
              (e) => e.reason,
              'reason',
              PaymentFailureReason.verificationFailed,
            ),
          ),
        );
      },
    );
  });

  group('active handler lifecycle', () {
    test(
      'active handler is cleared after success (cancel is a no-op)',
      () async {
        await useCase(req(PaymentMethod.terminal));
        useCase.cancel();
        verifyNever(() => terminal.cancel());
      },
    );

    test(
      'active handler is cleared after pay failure (cancel is a no-op)',
      () async {
        when(() => cash.pay(any())).thenThrow(const PaymentException('nope'));
        await expectLater(
          () => useCase(req(PaymentMethod.cash)),
          throwsA(isA<PaymentException>()),
        );
        useCase.cancel();
        verifyNever(() => cash.cancel());
      },
    );

    test(
      'cancel delegates to the in-flight handler during the charge',
      () async {
        final completer = Completer<OrderReceipt>();
        when(() => terminal.afterOrderCreated(any(), any())).thenAnswer(
          (_) => completer.future,
        );

        final future = useCase(req(PaymentMethod.terminal));
        await Future<void>.delayed(Duration.zero);
        useCase.cancel();
        verify(() => terminal.cancel()).called(1);

        completer.completeError(const PaymentException('done'));
        await expectLater(future, throwsA(isA<PaymentException>()));
      },
    );

    test('cancel is a harmless no-op when no payment is active', () {
      expect(() => useCase.cancel(), returnsNormally);
      verifyNever(() => terminal.cancel());
      verifyNever(() => cash.cancel());
    });
  });
}
