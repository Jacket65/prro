import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/config/network_timeouts.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/payment/data/models/payment_request.dart';
import 'package:prro/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:prro/features/payment/domain/payment_exceptions.dart';
import 'package:prro/features/payment/domain/repositories/terminal_payment_service_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiClient extends Mock implements ApiClientI {}

/// A backend reply the app never gets to see: an absent or unimplemented
/// terminal route.
DioException _endpointMissing({required int status}) => DioException(
  requestOptions: RequestOptions(path: '/retail-outlets/7/payments/create'),
  response: Response<dynamic>(
    requestOptions: RequestOptions(path: '/retail-outlets/7/payments/create'),
    statusCode: status,
    // Gin answers an unregistered route with a bare body, not the error
    // envelope `ApiException.fromDio` unwraps.
    data: '404 page not found',
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockApiClient apiClient;
  late PaymentRepositoryImpl repository;

  const createRequest = CreatePaymentRequest(
    amount: 15000,
    currency: 'UAH',
    description: 'Order payment',
    orderId: '42',
  );

  setUp(() async {
    apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({'outlet_id': 7});
    final prefs = await SharedPreferences.getInstance();
    repository = PaymentRepositoryImpl(
    apiClient: apiClient,
    outlets: OutletSession(prefs),
  );

    when(
      () => apiClient.post(
        any<String>(),
        data: any<dynamic>(named: 'data'),
        timeout: any(named: 'timeout'),
      ),
    ).thenAnswer(
      (inv) async => Response<dynamic>(
        requestOptions: RequestOptions(
          path: inv.positionalArguments.first as String,
        ),
        statusCode: 200,
        data: {
          'data': {
            'token': 'jwt-abc',
            'expires': '2026-01-01T10:00:00Z',
          },
        },
      ),
    );
  });

  group('createPaymentToken — endpoint availability', () {
    test('a 404 (absent route) becomes TerminalPaymentEndpointUnavailable',
        () async {
      when(
        () => apiClient.post(
          any<String>(),
          data: any<dynamic>(named: 'data'),
          timeout: any(named: 'timeout'),
        ),
      ).thenThrow(_endpointMissing(status: 404));

      await expectLater(
        () => repository.createPaymentToken(createRequest),
        throwsA(
          isA<TerminalPaymentEndpointUnavailableException>()
              .having(
                (e) => e.reason,
                'reason',
                PaymentFailureReason.terminalEndpointUnavailable,
              )
              .having(
                (e) => e.message,
                'message',
                contains('Оплата терміналом недоступна'),
              ),
        ),
      );
    });

    test('a 501 (explicitly not implemented) becomes '
        'TerminalPaymentEndpointUnavailable', () async {
      when(
        () => apiClient.post(
          any<String>(),
          data: any<dynamic>(named: 'data'),
          timeout: any(named: 'timeout'),
        ),
      ).thenThrow(_endpointMissing(status: 501));

      await expectLater(
        () => repository.createPaymentToken(createRequest),
        throwsA(isA<TerminalPaymentEndpointUnavailableException>()),
      );
    });

    test('a real failure still maps to ApiException', () async {
      when(
        () => apiClient.post(
          any<String>(),
          data: any<dynamic>(named: 'data'),
          timeout: any(named: 'timeout'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/retail-outlets/7/payments/create'),
          response: Response<dynamic>(
            requestOptions:
                RequestOptions(path: '/retail-outlets/7/payments/create'),
            statusCode: 500,
            data: {
              'error': {'code': 'internal_error', 'message': 'boom'},
            },
          ),
        ),
      );

      await expectLater(
        () => repository.createPaymentToken(createRequest),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    test('the happy path still returns the terminal token', () async {
      final token = await repository.createPaymentToken(createRequest);

      expect(token.token, 'jwt-abc');
      verify(
        () => apiClient.post(
          '/retail-outlets/7/payments/create',
          data: any<dynamic>(named: 'data'),
          timeout: NetworkTimeouts.payment,
        ),
      ).called(1);
    });
  });

  group('verifyPayment — endpoint availability', () {
    test('a 501 is reported as unavailable', () async {
      when(
        () => apiClient.post(
          any<String>(),
          data: any<dynamic>(named: 'data'),
          timeout: any(named: 'timeout'),
        ),
      ).thenThrow(_endpointMissing(status: 501));

      await expectLater(
        () => repository.verifyPayment('txn_123456'),
        throwsA(isA<TerminalPaymentEndpointUnavailableException>()),
      );
    });

    test('a 404 stays an ApiException — it may be an unknown transaction, '
        'not a missing route', () async {
      when(
        () => apiClient.post(
          any<String>(),
          data: any<dynamic>(named: 'data'),
          timeout: any(named: 'timeout'),
        ),
      ).thenThrow(_endpointMissing(status: 404));

      await expectLater(
        () => repository.verifyPayment('txn_123456'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
