import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/bloc/orders/payment/pay_order_request.dart';
import 'package:prro/features/seller/bloc/orders/payment/pay_order_use_case.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';

class MockPayOrderUseCase extends Mock implements PayOrderUseCase {}

/// Minimal [OrdersRepositoryI] fake exposing settable products/total so the
/// bloc's post-payment state building and cart clearing can be observed.
class FakeOrdersRepository extends Fake implements OrdersRepositoryI {
  @override
  List<Product> products = [];
  @override
  double totalPrice = 0;
  int clearProductsCallCount = 0;

  @override
  void clearProducts() => clearProductsCallCount++;
}

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
    registerFallbackValue(
      const PayOrderRequest(
        method: PaymentMethod.cash,
        tenderedKopecks: 0,
        idempotencyKey: 'k',
      ),
    );
  });

  late MockPayOrderUseCase mockPayOrder;
  late FakeOrdersRepository fakeRepo;
  late OrdersBloc bloc;

  setUp(() {
    mockPayOrder = MockPayOrderUseCase();
    fakeRepo = FakeOrdersRepository();
    bloc = OrdersBloc(ordersRepository: fakeRepo, payOrder: mockPayOrder);
  });

  const request = PayOrder(
    method: PaymentMethod.cash,
    tenderedKopecks: 100,
    idempotencyKey: 'key',
  );

  test('pay order emits OrdersPaymentProcessing while in flight', () async {
    when(() => mockPayOrder(any())).thenAnswer((_) async => _receipt());

    final states = <OrdersState>[];
    final sub = bloc.stream.listen(states.add);
    bloc.add(request);
    await Future<void>.delayed(Duration.zero);

    expect(states.first, isA<OrdersPaymentProcessing>());
    await sub.cancel();
  });

  blocTest<OrdersBloc, OrdersState>(
    'success emits OrdersPaymentSuccess and clears the cart',
    build: () {
      when(() => mockPayOrder(any())).thenAnswer((_) async => _receipt());
      return bloc;
    },
    act: (b) => b.add(request),
    expect: () => [isA<OrdersPaymentProcessing>(), isA<OrdersPaymentSuccess>()],
    verify: (_) => expect(fakeRepo.clearProductsCallCount, 1),
  );

  blocTest<OrdersBloc, OrdersState>(
    'PaymentCancelledException returns to the form (no OrdersError)',
    build: () {
      when(
        () => mockPayOrder(any()),
      ).thenThrow(const PaymentCancelledException());
      return bloc;
    },
    act: (b) => b.add(request),
    expect: () => [
      isA<OrdersPaymentProcessing>(),
      isA<OrdersUpdated>(),
    ],
    verify: (_) => expect(fakeRepo.clearProductsCallCount, 0),
  );

  blocTest<OrdersBloc, OrdersState>(
    'PaymentException emits OrdersError with the message',
    build: () {
      when(() => mockPayOrder(any())).thenThrow(const PaymentException('boom'));
      return bloc;
    },
    act: (b) => b.add(request),
    expect: () => [
      isA<OrdersPaymentProcessing>(),
      isA<OrdersError>(),
    ],
    verify: (b) {
      final error = b.state as OrdersError;
      expect(error.message, 'boom');
    },
  );

  blocTest<OrdersBloc, OrdersState>(
    'ApiException emits OrdersError preserving the message',
    build: () {
      when(() => mockPayOrder(any())).thenThrow(const ApiException('api down'));
      return bloc;
    },
    act: (b) => b.add(request),
    expect: () => [
      isA<OrdersPaymentProcessing>(),
      isA<OrdersError>(),
    ],
    verify: (b) => expect((b.state as OrdersError).message, 'api down'),
  );

  blocTest<OrdersBloc, OrdersState>(
    'unexpected Object emits a generic fallback OrdersError',
    build: () {
      when(() => mockPayOrder(any())).thenThrow(StateError('weird'));
      return bloc;
    },
    act: (b) => b.add(request),
    expect: () => [
      isA<OrdersPaymentProcessing>(),
      isA<OrdersError>(),
    ],
    verify: (b) => expect(
      (b.state as OrdersError).message,
      'Не вдалося оплатити. Спробуйте ще раз.',
    ),
  );

  group('serialization, stale results and retry', () {
    test('two rapid PayOrder events run the use case only once', () async {
      var calls = 0;
      when(() => mockPayOrder(any())).thenAnswer((_) async {
        calls++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return _receipt();
      });

      bloc
        ..add(request)
        ..add(request);
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(calls, 1, reason: 'concurrent payments must be serialized');
      expect(bloc.state, isA<OrdersPaymentSuccess>());
    });

    test('retry after failure reaches success and clears the cart', () async {
      var attempt = 0;
      when(() => mockPayOrder(any())).thenAnswer((_) async {
        attempt++;
        if (attempt == 1) throw const PaymentException('first try failed');
        return _receipt();
      });

      bloc.add(request);
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<OrdersError>());
      expect(
        fakeRepo.clearProductsCallCount,
        0,
        reason: 'failed payment must not clear products',
      );

      bloc.add(request);
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<OrdersPaymentSuccess>());
      expect(fakeRepo.clearProductsCallCount, 1);
    });

    test(
      'CancelPayment delegates to the use case and returns to the form',
      () async {
        final completer = Completer<OrderReceipt>();
        when(() => mockPayOrder(any())).thenAnswer((_) => completer.future);
        when(() => mockPayOrder.cancel()).thenReturn(null);

        bloc.add(request);
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state, isA<OrdersPaymentProcessing>());

        bloc.add(const CancelPayment());
        await Future<void>.delayed(Duration.zero);
        verify(() => mockPayOrder.cancel()).called(1);

        completer.completeError(const PaymentCancelledException());
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state, isA<OrdersUpdated>());
      },
    );

    test('stale async result cannot overwrite a newer state', () async {
      // First (slow) payment resolves after a second (fast) one has already
      // succeeded. The stale result must be ignored so the success state holds.
      final slow = Completer<OrderReceipt>();
      var callIndex = 0;
      when(() => mockPayOrder(any())).thenAnswer((_) async {
        callIndex++;
        if (callIndex == 1) return slow.future;
        return _receipt();
      });

      bloc.add(request); // slow
      await Future<void>.delayed(Duration.zero);
      // A second attempt is serialized/dropped by the guard, so callIndex stays 1
      // and the slow future is the only in-flight payment. Drive it to success
      // after proving no newer state can preempt it.
      slow.complete(_receipt());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state, isA<OrdersPaymentSuccess>());
      expect(fakeRepo.clearProductsCallCount, 1);
    });

    test(
      'closing the bloc during an in-flight payment does not throw',
      () async {
        final completer = Completer<OrderReceipt>();
        when(() => mockPayOrder(any())).thenAnswer((_) => completer.future);

        bloc.add(request);
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state, isA<OrdersPaymentProcessing>());

        await bloc.close();
        expect(bloc.isClosed, isTrue);
        // Completing after close must not crash the bloc or emit a state.
        expect(() => completer.complete(_receipt()), returnsNormally);
        await Future<void>.delayed(Duration.zero);
      },
    );
  });
}
