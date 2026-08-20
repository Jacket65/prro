import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';
import 'package:prro/features/seller/bloc/orders/payment/handlers/card_payment_handler.dart';
import 'package:prro/features/seller/bloc/orders/payment/handlers/cash_payment_handler.dart';
import 'package:prro/features/seller/bloc/orders/payment/handlers/nfc_payment_handler.dart';
import 'package:prro/features/seller/bloc/orders/payment/pay_order_request.dart';
import 'package:prro/features/seller/bloc/orders/payment/pay_order_use_case.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';

class MockCashHandler extends Mock implements CashPaymentHandler {}

class MockCardHandler extends Mock implements CardPaymentHandler {}

class MockNfcHandler extends Mock implements NfcPaymentHandler {}

class MockOrdersRepository extends Mock implements OrdersRepositoryI {}

OrderReceipt _receipt() => OrderReceipt(
  orderId: '1',
  lines: [],
  totalKopecks: 100,
  tenderedKopecks: 100,
  changeKopecks: 0,
  method: PaymentMethod.cash,
  status: 'paid',
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
    registerFallbackValue(
      const PayOrderRequest(
        method: PaymentMethod.cash,
        tenderedKopecks: 0,
        idempotencyKey: 'k',
      ),
    );
  });

  late MockCashHandler cash;
  late MockCardHandler card;
  late MockNfcHandler nfc;
  late MockOrdersRepository repo;
  late PayOrderUseCase useCase;

  setUp(() {
    cash = MockCashHandler();
    card = MockCardHandler();
    nfc = MockNfcHandler();
    repo = MockOrdersRepository();

    when(() => cash.method).thenReturn(PaymentMethod.cash);
    when(() => card.method).thenReturn(PaymentMethod.card);
    when(() => nfc.method).thenReturn(PaymentMethod.nfc);
    when(() => cash.pay(any())).thenAnswer((_) async {});
    when(() => card.pay(any())).thenAnswer((_) async {});
    when(() => nfc.pay(any())).thenAnswer((_) async {});
    when(() => cash.cancel()).thenReturn(null);
    when(() => card.cancel()).thenReturn(null);
    when(() => nfc.cancel()).thenReturn(null);
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
      card: card,
      nfc: nfc,
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
      verifyNever(() => card.pay(any()));
      verifyNever(() => nfc.pay(any()));
    });

    test('card request uses the card handler only', () async {
      await useCase(req(PaymentMethod.card));
      verify(() => card.pay(any())).called(1);
      verifyNever(() => cash.pay(any()));
      verifyNever(() => nfc.pay(any()));
    });

    test('nfc request uses the nfc handler only', () async {
      await useCase(req(PaymentMethod.nfc));
      verify(() => nfc.pay(any())).called(1);
      verifyNever(() => cash.pay(any()));
      verifyNever(() => card.pay(any()));
    });

    test(
      'placeOrder throwing propagates and clears the active handler',
      () async {
        when(
          () => repo.placeOrder(
            method: any(named: 'method'),
            tenderedKopecks: any(named: 'tenderedKopecks'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).thenThrow(const ApiException('store closed'));
        await expectLater(
          () => useCase(req(PaymentMethod.cash)),
          throwsA(isA<ApiException>()),
        );
        useCase.cancel();
        verifyNever(() => cash.cancel());
      },
    );
  });

  group('pay request + placeOrder', () {
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
  });

  group('active handler lifecycle', () {
    test(
      'active handler is cleared after success (cancel is a no-op)',
      () async {
        await useCase(req(PaymentMethod.nfc));
        useCase.cancel();
        verifyNever(() => nfc.cancel());
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

    test('cancel delegates to the in-flight handler', () async {
      final completer = Completer<void>();
      when(() => nfc.pay(any())).thenAnswer((_) => completer.future);

      final future = useCase(req(PaymentMethod.nfc));
      await Future<void>.delayed(Duration.zero);
      useCase.cancel();
      verify(() => nfc.cancel()).called(1);

      completer.completeError(const PaymentException('done'));
      await expectLater(future, throwsA(isA<PaymentException>()));
    });

    test('cancel is a harmless no-op when no payment is active', () {
      expect(() => useCase.cancel(), returnsNormally);
      verifyNever(() => nfc.cancel());
      verifyNever(() => cash.cancel());
      verifyNever(() => card.cancel());
    });
  });
}
