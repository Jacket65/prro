import 'package:injectable/injectable.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';

@Environment('prod')
@Singleton(as: OrderHistoryRepositoryI)
class OrderHistoryRepositoryImpl implements OrderHistoryRepositoryI {
  OrderHistoryRepositoryImpl({
    required this._apiClient,
    required this._outlets,
  });
  final ApiClientI _apiClient;
  final OutletSession _outlets;

  @override
  Future<Page<ShiftSummary>> getShifts({
    int page = 1,
    String sort = 'opened_at',
    String order = 'desc',
    int? outletId,
  }) => dioGuard(() async {
    final response = await _apiClient.get(
      '/retail-outlets/${outletId ?? _outlets.id()}/shifts',
      queryParameters: {'page': page, 'sort': sort, 'order': order},
    );
    return Page<ShiftSummary>.fromJson(
      (response.data as Map).cast<String, dynamic>(),
      ShiftSummary.fromJson,
    );
  });

  @override
  Future<Page<OrderListItem>> getShiftOrders(
    int shiftId, {
    required String sort,
    required String order,
    int page = 1,
  }) => dioGuard(() async {
    final response = await _apiClient.get(
      '/shifts/$shiftId/orders',
      queryParameters: {'page': page, 'sort': sort, 'order': order},
    );
    return Page<OrderListItem>.fromJson(
      (response.data as Map).cast<String, dynamic>(),
      OrderListItem.fromJson,
    );
  });

  @override
  Future<OrderDetail> getOrder(int orderId) => dioGuard(() async {
    final response = await _apiClient.get('/orders/$orderId');
    return OrderDetail.fromJson(
      (response.data as Map).cast<String, dynamic>(),
    );
  });
}
