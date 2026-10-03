import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/utils/json.dart';
import 'package:prro/features/payment/data/models/payment_request.dart';
import 'package:prro/features/payment/data/models/payment_result.dart';
import 'package:prro/features/payment/data/models/payment_token.dart';
import 'package:prro/features/payment/domain/repositories/payment_repository_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Production implementation of [PaymentRepositoryI].
///
/// The terminal endpoints are `POST /retail-outlets/{id}/payments/create` and
/// `.../payments/check`; the backend signs the create request and obtains a JWT
/// from PrivatBank.
@LazySingleton(as: PaymentRepositoryI, env: [Environment.prod])
class PaymentRepositoryImpl implements PaymentRepositoryI {
  PaymentRepositoryImpl({required this._apiClient, required this._prefs});

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
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request) async {
    try {
      final response = await _apiClient.post(
        '/retail-outlets/${_outletId()}/payments/create',
        data: request.toJson(),
      );
      return TerminalToken.fromJson(unwrapPayload(response.data)!);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<PaymentResult> verifyPayment(String transactionId) async {
    try {
      final response = await _apiClient.post(
        '/retail-outlets/${_outletId()}/payments/check',
        data: {'transaction_id': transactionId},
      );
      return PaymentResult.fromJson(unwrapPayload(response.data)!);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
