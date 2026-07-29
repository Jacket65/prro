import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/shift.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shift endpoints are scoped under the outlet — there is no `/shifts` group:
///   GET   /retail-outlets/{id}/shift/current   → 200 ShiftResponse | 404 none
///   POST  /retail-outlets/{id}/shift/open      {"cash_start":"0.00"}  (+ Idem)
///   PATCH /retail-outlets/{id}/shift/close     {"cash_end":"0.00"}    (+ Idem)
///
/// The backend is the single source of truth for the shift state — we cache
/// nothing in prefs here.
@Environment('prod')
@Singleton(as: ShiftServiceI)
class ShiftService implements ShiftServiceI {
  ShiftService({
    required this._apiClient,
    required this._prefs,
  });
  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  int _outletId() {
    final id = _prefs.getInt('outlet_id');
    if (id == null) {
      throw const ApiException('Точку продажу не визначено. Увійдіть знову.');
    }
    return id;
  }

  ShiftResponse _parse(dynamic body) {
    final data = body is Map && body['data'] is Map
        ? (body['data'] as Map).cast<String, dynamic>()
        : (body as Map).cast<String, dynamic>();
    return ShiftResponse.fromJson(data);
  }

  @override
  Future<ShiftResponse?> currentShift() async {
    try {
      final response = await _apiClient.get(
        '/retail-outlets/${_outletId()}/shift/current',
      );
      return _parse(response.data);
    } on DioException catch (e) {
      // 404 is a normal state ("no open shift"), not an error — surface it as
      // null so the UI can show the "open shift" gate without a toast.
      if (e.response?.statusCode == 404) return null;
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<ShiftResponse> openShift({
    required String idempotencyKey,
    String cashStart = '0.00',
  }) async {
    try {
      final response = await _apiClient.post(
        '/retail-outlets/${_outletId()}/shift/open',
        data: {'cash_start': cashStart},
        idempotencyKey: idempotencyKey,
      );
      return _parse(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> closeShift({
    required String cashEnd,
    required String idempotencyKey,
  }) async {
    try {
      await _apiClient.patch(
        '/retail-outlets/${_outletId()}/shift/close',
        data: {'cash_end': cashEnd},
        idempotencyKey: idempotencyKey,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
