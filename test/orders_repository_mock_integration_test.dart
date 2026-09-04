import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/data/api/models/measure_unit.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository_mock.dart';
import 'package:prro/data/services/order_history_service_mock.dart';

void main() {
  group('OrdersRepositoryMock integration with OrderHistoryServiceMock', () {
    late MockBackend backend;
    late OrderHistoryServiceMock historyService;
    late OrdersRepositoryMock ordersRepository;

    setUp(() {
      backend = MockBackend.instance;
      historyService = OrderHistoryServiceMock();
      ordersRepository = OrdersRepositoryMock(backend, historyService);
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

      // 2. Initial state check: no custom orders in history
      final initialShifts = await historyService.getShifts();
      expect(initialShifts.items, isNotEmpty);
      final activeShift = initialShifts.items.first;

      // final initialOrders = await historyService.getShiftOrders(
      //   activeShift.id,
      //   sort: 'created_at',
      //   order: 'desc',
      // );
      // final initialCount = initialOrders.items.length;

      // 3. Place order
      final receipt = await ordersRepository.placeOrder(
        method: PaymentMethod.cash,
        tenderedKopecks: 3500,
        idempotencyKey: 'test-key-${DateTime.now().millisecondsSinceEpoch}',
      );

      // 4. History service check: order must be added
      final updatedOrders = await historyService.getShiftOrders(
        activeShift.id,
        sort: 'created_at',
        order: 'desc',
      );
      // Because of pagination, the page size is capped at 10.
      // But since the new order is the most recent, it must be the first item.
      final newOrderId = int.parse(receipt.orderId);
      expect(updatedOrders.items.first.orderId, newOrderId);

      // Check order details can be retrieved correctly
      final detail = await historyService.getOrder(newOrderId);
      expect(detail.orderId, newOrderId);
      expect(detail.shiftId, activeShift.id);
      expect(detail.totalKopecks, 3500);
      expect(detail.items.length, 1);
      expect(detail.items.first.name, contains('Еспресо'));
    });
  });
}
