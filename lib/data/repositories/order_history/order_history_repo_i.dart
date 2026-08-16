import 'package:prro/data/api/models/order_history.dart';

abstract interface class OrderHistoryRepositoryI {
  /// `GET /retail-outlets/{outlet_id}/shifts?page&sort&order`.
  Future<Page<ShiftSummary>> getShifts({
    int page = 1,
    String sort = 'opened_at',
    String order = 'desc',
  });

  /// `GET /shifts/{shift_id}/orders?page&sort&order`.
  Future<Page<OrderListItem>> getShiftOrders(
    int shiftId, {
    required String sort, required String order, int page = 1,
  });

  /// `GET /orders/{order_id}` — the full receipt.
  Future<OrderDetail> getOrder(int orderId);
}
