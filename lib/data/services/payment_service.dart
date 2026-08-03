import 'package:dio/dio.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/api/models/payment/payment_result.dart';
import 'package:prro/data/api/models/payment/payment_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service interface for payment-related API calls.
abstract interface class PaymentServiceI {
  /// Creates a payment token by calling the backend.
  /// The backend signs the request and obtains a JWT from PrivatBank.
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request);

  /// Verifies a payment by transaction ID.
  Future<PaymentResult> verifyPayment(String transactionId);
}

/// Production implementation of [PaymentServiceI].
class PaymentService implements PaymentServiceI {
  PaymentService({
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

  @override
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request) async {
    try {
      final response = await _apiClient.post(
        '/retail-outlets/${_outletId()}/payments/create',
        data: request.toJson(),
      );
      final raw = response.data;
      final data = raw is Map && raw['data'] is Map
          ? (raw['data'] as Map).cast<String, dynamic>()
          : (raw as Map).cast<String, dynamic>();
      return TerminalToken.fromJson(data);
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
      final raw = response.data;
      final data = raw is Map && raw['data'] is Map
          ? (raw['data'] as Map).cast<String, dynamic>()
          : (raw as Map).cast<String, dynamic>();
      return PaymentResult.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
