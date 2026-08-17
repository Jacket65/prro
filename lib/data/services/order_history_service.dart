import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OrderHistoryServiceI {
  /// `GET /retail-outlets/{outlet_id}/shifts?page&sort&order`.
  ///
  /// When [outletId] is null the seller's default outlet (from
  /// `SharedPreferences`) is used; admin passes an explicit outlet.
  Future<Page<ShiftSummary>> getShifts({
    int page = 1,
    String sort = 'opened_at',
    String order = 'desc',
    int? outletId,
  });

  /// `GET /shifts/{shift_id}/orders?page&sort&order`.
  Future<Page<OrderListItem>> getShiftOrders(
    int shiftId, {
    required String sort, required String order, int page = 1,
  });

  /// `GET /orders/{order_id}` — the full receipt.
  Future<OrderDetail> getOrder(int orderId);
}

@Environment('prod')
@Singleton(as: OrderHistoryServiceI)
class OrderHistoryService implements OrderHistoryServiceI {
  OrderHistoryService({required this._apiClient, required this._prefs});
  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  int _outletId() {
    final id = _prefs.getInt('outlet_id');
    if (id == null) {
      throw const ApiException('Точку продажу не визначено. Увійдіть знову.');
    }
    return id;
  }

  @override
  Future<Page<ShiftSummary>> getShifts({
    int page = 1,
    String sort = 'opened_at',
    String order = 'desc',
    int? outletId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/retail-outlets/${outletId ?? _outletId()}/shifts',
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
    required String sort, required String order, int page = 1,
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
