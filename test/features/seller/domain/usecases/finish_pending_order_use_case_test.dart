import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_outcome.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_use_case.dart';

class MockPendingOrderStore extends Mock implements PendingOrderStoreI {}

class MockOrderHistoryRepository extends Mock
    implements OrderHistoryRepositoryI {}

class MockOrdersRepository extends Mock implements OrdersRepositoryI {}

OrderDetail _detail({
  int orderId = 1042,
  String status = 'pending',
  int totalKopecks = 45000,
}) => OrderDetail(
  orderId: orderId,
  shiftId: 7,
  status: status,
  createdAt: DateTime(2026, 1, 1, 12),
  totalKopecks: totalKopecks,
  items: const [],
  payment: OrderDetailPayment(
    method: PaymentMethod.terminal,
    tenderedKopecks: totalKopecks,
    changeKopecks: 0,
    totalKopecks: totalKopecks,
  ),
);

PendingOrder _pending({
  String orderId = '1042',
  String idempotencyKey = 'key-42',
}) => PendingOrder(
  orderId: orderId,
  idempotencyKey: idempotencyKey,
  createdAt: DateTime(2026, 1, 1, 12),
);

OrderReceipt _receipt() => OrderReceipt(
  orderId: '1042',
  lines: const [],
  totalKopecks: 45000,
  tenderedKopecks: 45000,
  changeKopecks: 0,
  method: PaymentMethod.terminal,
  status: 'completed',
  issuedAt: DateTime(2026, 1, 1, 12),
  storeName: 'Store',
  cashierName: 'Cashier',
);

void main() {
  late MockPendingOrderStore store;
  late MockOrderHistoryRepository history;
  late MockOrdersRepository orders;
  late FinishPendingOrderUseCase useCase;

  setUp(() {
    store = MockPendingOrderStore();
    history = MockOrderHistoryRepository();
    orders = MockOrdersRepository();
    useCase = FinishPendingOrderUseCase(
      pendingOrderStore: store,
      orderHistoryRepository: history,
      ordersRepository: orders,
    );

    when(() => store.clear()).thenAnswer((_) async {});
  });

  group('load', () {
    test('nothing stored yields NoPendingOrder', () async {
      when(() => store.read()).thenReturn(null);

      expect(await useCase.load(), isA<NoPendingOrder>());
      verifyNever(() => history.getOrder(any()));
    });

    test('a completed order is reported as settled and the record is dropped',
        () async {
      when(() => store.read()).thenReturn(_pending());
      when(() => history.getOrder(1042)).thenAnswer(
        (_) async => _detail(status: 'completed'),
      );

      final outcome = await useCase.load();

      expect(outcome, isA<PendingOrderAlreadySettled>());
      verify(() => store.clear()).called(1);
    });

    test('a pending order is offered with the receipt total', () async {
      when(() => store.read()).thenReturn(_pending());
      when(() => history.getOrder(1042)).thenAnswer((_) async => _detail());

      final outcome = await useCase.load();

      expect(
        outcome,
        isA<PendingOrderUnfinished>()
            .having((o) => o.orderId, 'orderId', '1042')
            .having((o) => o.totalKopecks, 'totalKopecks', 45000)
            .having((o) => o.idempotencyKey, 'idempotencyKey', 'key-42'),
      );
    });

    test('an unreadable receipt still offers the order, without a total',
        () async {
      when(() => store.read()).thenReturn(_pending());
      when(() => history.getOrder(1042)).thenThrow(
        const ApiException('Не знайдено.', code: 'not_found', statusCode: 404),
      );

      final outcome = await useCase.load();

      expect(outcome, isA<PendingOrderUnfinished>());
      final unfinished = outcome as PendingOrderUnfinished;
      expect(unfinished.orderId, '1042');
      expect(unfinished.totalKopecks, isNull);
      verifyNever(() => store.clear());
    });
  });

  group('confirm', () {
    test('a successful confirm clears the record', () async {
      when(() => orders.confirmOrder(1042)).thenAnswer(
        (_) async => _receipt(),
      );

      final outcome = await useCase.confirm(_pending());

      expect(outcome, isA<PendingOrderConfirmed>());
      verify(() => store.clear()).called(1);
    });

    test('a 404 means the shift is closed: clears and says so', () async {
      when(() => orders.confirmOrder(1042)).thenThrow(
        const ApiException('Не знайдено.', code: 'not_found', statusCode: 404),
      );

      final outcome = await useCase.confirm(_pending());

      expect(outcome, isA<PendingOrderShiftClosed>());
      verify(() => store.clear()).called(1);
    });

    test('any other failure keeps the record so a retry is possible', () async {
      when(() => orders.confirmOrder(1042)).thenThrow(
        const ApiException('Помилка сервера.', statusCode: 500),
      );

      final outcome = await useCase.confirm(_pending());

      expect(outcome, isA<PendingOrderConfirmFailed>());
      verifyNever(() => store.clear());
    });

    test('a transport failure keeps the record too', () async {
      when(() => orders.confirmOrder(1042)).thenThrow(StateError('offline'));

      final outcome = await useCase.confirm(_pending());

      expect(outcome, isA<PendingOrderConfirmFailed>());
      verifyNever(() => store.clear());
    });

    test('an order id that is not a server-side id is dropped, not retried '
        'forever', () async {
      final outcome = await useCase.confirm(
        _pending(orderId: 'not-a-number'),
      );

      expect(outcome, isA<PendingOrderConfirmFailed>());
      verify(() => store.clear()).called(1);
      verifyNever(() => orders.confirmOrder(any()));
    });

    test('confirm uses the stored id, parsed as a server-side id', () async {
      when(() => orders.confirmOrder(1042)).thenAnswer(
        (_) async => _receipt(),
      );

      await useCase.confirm(_pending());

      verify(() => orders.confirmOrder(1042)).called(1);
    });
  });

  group('reject', () {
    test('drops only the local record', () async {
      await useCase.reject();

      verify(() => store.clear()).called(1);
      verifyNever(() => orders.confirmOrder(any()));
      verifyNever(() => history.getOrder(any()));
    });
  });
}
