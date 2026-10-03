import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Environment('prod')
@Singleton(as: OrderHistoryRepositoryI)
class OrderHistoryRepositoryImpl implements OrderHistoryRepositoryI {
  OrderHistoryRepositoryImpl({required this._apiClient, required this._prefs});
  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  @override
  Future<Page<ShiftSummary>> getShifts({
    int page = 1,
    String sort = 'opened_at',
    String order = 'desc',
    int? outletId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/retail-outlets/${outletId ?? requireOutletId(_prefs)}/shifts',
        queryParameters: {'page': page, 'sort': sort, 'order': order},
      );
      return Page<ShiftSummary>.fromJson(
        (response.data as Map).cast<String, dynamic>(),
        ShiftSummary.fromJson,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<Page<OrderListItem>> getShiftOrders(
    int shiftId, {
    required String sort,
    required String order,
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.get(
        '/shifts/$shiftId/orders',
        queryParameters: {'page': page, 'sort': sort, 'order': order},
      );
      return Page<OrderListItem>.fromJson(
        (response.data as Map).cast<String, dynamic>(),
        OrderListItem.fromJson,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<OrderDetail> getOrder(int orderId) async {
    try {
      final response = await _apiClient.get('/orders/$orderId');
      return OrderDetail.fromJson(
        (response.data as Map).cast<String, dynamic>(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
