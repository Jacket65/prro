import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:prro/data/repositories/order_history/order_history_repo_i.dart';
import 'package:prro/data/services/order_history_service.dart';

@Environment('mock')
@Singleton(as: OrderHistoryRepositoryI)
class OrderHistoryRepositoryMock implements OrderHistoryRepositoryI {
  OrderHistoryRepositoryMock(this._service);
  final OrderHistoryServiceI _service;

  @override
  Future<Page<ShiftSummary>> getShifts({
    int page = 1,
    String sort = 'opened_at',
    String order = 'desc',
    int? outletId,
  }) =>
      _service.getShifts(
        page: page,
        sort: sort,
        order: order,
        outletId: outletId,
      );

  @override
  Future<Page<OrderListItem>> getShiftOrders(
    int shiftId, {
    required String sort, required String order, int page = 1,
  }) =>
      _service.getShiftOrders(
        shiftId,
        page: page,
        sort: sort,
        order: order,
      );

  @override
  Future<OrderDetail> getOrder(int orderId) => _service.getOrder(orderId);
}
