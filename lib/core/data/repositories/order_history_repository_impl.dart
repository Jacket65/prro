import 'package:injectable/injectable.dart';
import 'package:prro/core/data/services/order_history_service.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';

@Environment('prod')
@Singleton(as: OrderHistoryRepositoryI)
class OrderHistoryRepositoryImpl implements OrderHistoryRepositoryI {
  OrderHistoryRepositoryImpl(this._service);
  final OrderHistoryServiceI _service;

  @override
  Future<Page<ShiftSummary>> getShifts({
    int page = 1,
    String sort = 'opened_at',
    String order = 'desc',
    int? outletId,
  }) => _service.getShifts(
    page: page,
    sort: sort,
    order: order,
    outletId: outletId,
  );

  @override
  Future<Page<OrderListItem>> getShiftOrders(
    int shiftId, {
    required String sort,
    required String order,
    int page = 1,
  }) => _service.getShiftOrders(
    shiftId,
    page: page,
    sort: sort,
    order: order,
  );

  @override
  Future<OrderDetail> getOrder(int orderId) => _service.getOrder(orderId);
}
