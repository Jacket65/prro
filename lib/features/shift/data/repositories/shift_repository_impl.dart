import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/utils/json.dart';
import 'package:prro/features/shift/domain/entities/shift.dart';
import 'package:prro/features/shift/domain/repositories/shift_repository_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shift endpoints are scoped under the outlet — there is no `/shifts` group:
///   GET   /retail-outlets/{id}/shift/current   → 200 ShiftResponse | 404 none
///   POST  /retail-outlets/{id}/shift/open      {"cash_start":"0.00"}  (+ Idem)
///   POST  /retail-outlets/{id}/shift/close     {"cash_end":"0.00"}    (+ Idem)
///
/// The backend is the single source of truth for the shift state — we cache
/// nothing in prefs here.
@Environment('prod')
@Singleton(as: ShiftRepositoryI)
class ShiftRepositoryImpl implements ShiftRepositoryI {
  ShiftRepositoryImpl({required this._apiClient, required this._prefs});
  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  ShiftResponse _parse(dynamic body) => ShiftResponse.fromJson(
    // A body with no object payload is a protocol violation: fail rather than
    // hand the parser something it cannot read.
    unwrapPayload(body)!,
  );

  @override
  Future<ShiftResponse?> currentShift() async {
    try {
      final response = await _apiClient.get(
        '/retail-outlets/${requireOutletId(_prefs)}/shift/current',
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
        '/retail-outlets/${requireOutletId(_prefs)}/shift/open',
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
      await _apiClient.post(
        '/retail-outlets/${requireOutletId(_prefs)}/shift/close',
        data: {'cash_end': cashEnd},
        idempotencyKey: idempotencyKey,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
