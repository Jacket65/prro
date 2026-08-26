import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/services/login_service.dart';

class MockApiClient extends Mock implements ApiClientI {}

class _FakeRequestOptions extends Fake implements RequestOptions {}

Response<dynamic> _resp({
  int status = 200,
  Map<String, dynamic>? body,
  String? bearer,
}) {
  final headers = Headers.fromMap({
    if (bearer != null) 'authorization': [bearer],
  });
  return Response<dynamic>(
    requestOptions: RequestOptions(path: '/auth/login'),
    statusCode: status,
    data: body,
    headers: headers,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRequestOptions());
  });

  late MockApiClient apiClient;
  late LoginService service;

  setUp(() {
    apiClient = MockApiClient();
    service = LoginService(apiClient: apiClient);
  });

  test('F8: reads outlet_id from login response (no extra call)', () async {
    when(
      () => apiClient.post(
        any<String>(),
        data: any<dynamic>(named: 'data'),
      ),
    ).thenAnswer(
      (_) async => _resp(
        bearer: 'Bearer token-1',
        body: {
          'data': {
            'id': 42,
            'login': 'cashier',
            'role': 'cashier',
            'outlet_id': 7,
            'refresh_token': 'r',
          },
        },
      ),
    );

    final result = await service.login(
      username: 'cashier',
      password: 'pw',
    );

    expect(result.accessToken, 'token-1');
    expect(result.outletId, 7);
    expect(result.userId, 42);
    expect(result.role, 'cashier');
    expect(result.refreshToken, 'r');
    verifyNever(
      () => apiClient.get(any<String>(), headers: any(named: 'headers')),
    );
  });

  test('F1: wraps DioException into ApiException', () async {
    final dioErr = DioException(
      requestOptions: RequestOptions(path: '/auth/login'),
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/auth/login'),
        statusCode: 401,
        data: {
          'error': {
            'code': 'UNAUTHORIZED',
            'message': 'Невірний логін або пароль',
          },
        },
      ),
      type: DioExceptionType.badResponse,
    );
    when(
      () => apiClient.post(any<String>(), data: any<dynamic>(named: 'data')),
    ).thenThrow(dioErr);

    expect(
      () => service.login(username: 'u', password: 'p'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Невірний логін або пароль',
        ),
      ),
    );
  });

  test(
    'returns accessToken empty if server returns 200 without body',
    () async {
      when(
        () => apiClient.post(any<String>(), data: any<dynamic>(named: 'data')),
      ).thenAnswer(
        (_) async => _resp(status: 401, body: {'code': 'INVALID'}),
      );

      expect(
        () => service.login(username: 'u', password: 'p'),
        throwsA(isA<ApiException>()),
      );
    },
  );

  test('throws when Authorization header is missing', () async {
    when(
      () => apiClient.post(any<String>(), data: any<dynamic>(named: 'data')),
    ).thenAnswer(
      (_) async => _resp(
        body: {
          'data': {'role': 'admin', 'id': 1, 'outlet_id': 1},
        },
      ),
    );

    expect(
      () => service.login(username: 'u', password: 'p'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.code,
          'code',
          'MISSING_ACCESS_TOKEN',
        ),
      ),
    );
  });

  test('F8/F10: tolerates bare object without data envelope', () async {
    when(
      () => apiClient.post(any<String>(), data: any<dynamic>(named: 'data')),
    ).thenAnswer(
      (_) async => _resp(
        bearer: 'Bearer t',
        body: {
          'id': 1,
          'role': 'admin',
          'outlet_id': 3,
        },
      ),
    );

    final result = await service.login(username: 'a', password: 'b');
    expect(result.outletId, 3);
    expect(result.role, 'admin');
  });
}
