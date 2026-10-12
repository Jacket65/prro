import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/data/mock/order_history_repository_mock.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/features/seller/data/mock/orders_repository_mock.dart';

void main() {
  group('OrdersRepositoryMock integration with OrderHistoryRepositoryMock', () {
    late MockBackend backend;
    late OrderHistoryRepositoryMock historyRepository;
    late OrdersRepositoryMock ordersRepository;

    setUp(() {
      backend = MockBackend.instance;
      historyRepository = OrderHistoryRepositoryMock();
      ordersRepository = OrdersRepositoryMock(backend, historyRepository);
    });

    test('placing a mock order adds it to the mock history service', () async {
      // 1. Prepare products to place
      final product = Product(
        id: '1', // Espresso variant ID
        name: 'Еспресо',
        price: 35,
        imageUrl: '',
        quantity: Decimal.one,
        unit: MeasureUnit(id: 3, name: 'шт', step: Decimal.one),
      );

      ordersRepository.addProduct(product);

      // 2. Resolve the open shift the mock backend is currently serving. It is
      // pre-seeded with orders, so the check that matters is the one in step 4:
      // the order placed below comes back as the newest row.
      final initialShifts = await historyRepository.getShifts();
      expect(initialShifts.items, isNotEmpty);
      final activeShift = initialShifts.items.first;

      // 3. Place order — an over-tender (the customer hands over 50.00 for a
      // 35.00 line). The mock backend must compute the change from the
      // difference, exactly like the real one (see R5).
      final receipt = await ordersRepository.placeOrder(
        method: PaymentMethod.cash,
        tenderedKopecks: 5000,
        idempotencyKey: 'test-key-${DateTime.now().millisecondsSinceEpoch}',
      );

      expect(receipt.tenderedKopecks, 5000);
      expect(receipt.changeKopecks, 1500);

      // 4. History service check: order must be added
      final updatedOrders = await historyRepository.getShiftOrders(
        activeShift.id,
        sort: 'created_at',
        order: 'desc',
      );
      // Because of pagination, the page size is capped at 10.
      // But since the new order is the most recent, it must be the first item.
      final newOrderId = int.parse(receipt.orderId);
      expect(updatedOrders.items.first.orderId, newOrderId);

      // Check order details can be retrieved correctly
      final detail = await historyRepository.getOrder(newOrderId);
      expect(detail.orderId, newOrderId);
      expect(detail.shiftId, activeShift.id);
      expect(detail.totalKopecks, 3500);
      expect(detail.items.length, 1);
      expect(detail.items.first.name, contains('Еспресо'));
    });

    test(
      'terminal order stays pending until confirmOrder completes it',
      () async {
        final product = Product(
          id: '1',
          name: 'Еспресо',
          price: 35,
          imageUrl: '',
          quantity: Decimal.one,
          unit: MeasureUnit(id: 3, name: 'шт', step: Decimal.one),
        );
        ordersRepository.addProduct(product);

        final receipt = await ordersRepository.placeOrder(
          method: PaymentMethod.terminal,
          tenderedKopecks: 3500,
          idempotencyKey: 'terminal-${DateTime.now().millisecondsSinceEpoch}',
        );

        expect(receipt.method, PaymentMethod.terminal);
        expect(receipt.status, 'pending');

        final confirmed = await ordersRepository.confirmOrder(
          int.parse(receipt.orderId),
        );

        expect(confirmed.orderId, receipt.orderId);
        expect(confirmed.status, 'completed');

        // Re-confirm is harmless (the real backend answers 409).
        final again = await ordersRepository.confirmOrder(
          int.parse(receipt.orderId),
        );
        expect(again.status, 'completed');
      },
    );
  });
}
