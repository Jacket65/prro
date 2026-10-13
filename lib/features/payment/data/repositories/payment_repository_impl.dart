import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/config/network_timeouts.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/utils/envelope.dart';
import 'package:prro/features/payment/data/models/payment_request.dart';
import 'package:prro/features/payment/data/models/payment_result.dart';
import 'package:prro/features/payment/data/models/payment_token.dart';
import 'package:prro/features/payment/domain/repositories/payment_repository_i.dart';
import 'package:prro/features/payment/domain/repositories/terminal_payment_service_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Production implementation of [PaymentRepositoryI].
///
/// The terminal endpoints are `POST /retail-outlets/{id}/payments/create` and
/// `.../payments/check`; the backend signs the create request and obtains a JWT
/// from PrivatBank.
///
/// Not every backend exposes those routes yet. The paths, the methods and the
/// cashier-facing option all stay: the only change is that an absent route is
/// reported as [TerminalPaymentEndpointUnavailableException] instead of a
/// generic [ApiException], so the seller is told card payment is unavailable
/// rather than shown an opaque server error.
@LazySingleton(as: PaymentRepositoryI, env: [Environment.prod])
class PaymentRepositoryImpl implements PaymentRepositoryI {
  PaymentRepositoryImpl({required this._apiClient, required this._prefs});

  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  @override
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request) async {
    try {
      final response = await _apiClient.post(
        '/retail-outlets/${requireOutletId(_prefs)}/payments/create',
        data: request.toJson(),
        timeout: NetworkTimeouts.payment,
      );
      return TerminalToken.fromJson(unwrapPayload(response.data)!);
    } on DioException catch (e) {
      // A 404 here can only mean the route is absent: the request is
      // well-formed and the outlet comes from the signed-in session. Gin
      // answers an unregistered route with a bare 404 (no error envelope), so
      // `ApiException.fromDio` would render it as "Помилка сервера (404)" —
      // true but useless to a cashier. 501 is the explicit "not implemented".
      final status = e.response?.statusCode;
      if (status == 404 || status == 501) {
        throw const TerminalPaymentEndpointUnavailableException();
      }
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<PaymentResult> verifyPayment(String transactionId) async {
    try {
      final response = await _apiClient.post(
        '/retail-outlets/${requireOutletId(_prefs)}/payments/check',
        data: {'transaction_id': transactionId},
        timeout: NetworkTimeouts.payment,
      );
      return PaymentResult.fromJson(unwrapPayload(response.data)!);
    } on DioException catch (e) {
      // Only an explicit "not implemented" is an availability signal here: a
      // 404 may also mean the transaction id is unknown to a backend that does
      // implement the route, and reporting that as "terminal unavailable"
      // would be a lie. When the whole path is missing the flow already failed
      // at `createPaymentToken`.
      if (e.response?.statusCode == 501) {
        throw const TerminalPaymentEndpointUnavailableException();
      }
      throw ApiException.fromDio(e);
    }
  }
}
