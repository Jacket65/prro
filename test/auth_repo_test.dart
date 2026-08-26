import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
import 'package:prro/features/auth/model/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiClient extends Mock implements ApiClientI {}

class MockTokenStorage extends Mock implements TokenStorageI {}

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
    registerFallbackValue(<String, dynamic>{});
  });

  late MockApiClient apiClient;
  late MockTokenStorage tokenStorage;
  late SharedPreferences prefs;
  late AuthRepositoryImpl repo;

  setUp(() async {
    apiClient = MockApiClient();
    tokenStorage = MockTokenStorage();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    when(() => tokenStorage.saveSession(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        )).thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});

    repo = AuthRepositoryImpl(
      tokenStorage: tokenStorage,
      apiClient: apiClient,
      prefs: prefs,
    );
  });

  void stubLogin(Response<dynamic> response) {
    when(
      () => apiClient.post(any<String>(), data: any<dynamic>(named: 'data')),
    ).thenAnswer((_) async => response);
  }

  group('F9: role parsing', () {
    test('maps cashier to seller', () async {
      stubLogin(
        _resp(
          bearer: 'Bearer tok',
          body: {
            'data': {
              'id': 1,
              'role': 'cashier',
              'outlet_id': 1,
              'refresh_token': 'r',
            },
          },
        ),
      );
      final user = await repo.login(username: 'cashier', password: 'p');
      expect(user.role, UserRole.seller);
    });

    test('maps admin to admin', () async {
      stubLogin(
        _resp(
          bearer: 'Bearer tok',
          body: {
            'data': {
              'id': 1,
              'role': 'admin',
              'outlet_id': 1,
            },
          },
        ),
      );
      final user = await repo.login(username: 'a', password: 'p');
      expect(user.role, UserRole.admin);
    });

    test('F9: throws invalidCredentials on unknown role', () async {
      stubLogin(
        _resp(
          bearer: 'Bearer tok',
          body: {
            'data': {
              'id': 1,
              'role': 'supervisor',
              'outlet_id': 1,
            },
          },
        ),
      );
      expect(
        () => repo.login(username: 'a', password: 'p'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.invalidCredentials,
          ),
        ),
      );
    });
  });

  group('F5: outlet validation', () {
    test('treats missing outlet as invalid credentials', () async {
      stubLogin(
        _resp(
          bearer: 'Bearer tok',
          body: {
            'data': {
              'id': 1,
              'role': 'cashier',
            },
          },
        ),
      );
      expect(
        () => repo.login(username: 'a', password: 'p'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.invalidCredentials,
          ),
        ),
      );
    });

    test('treats zero outlet as invalid credentials', () async {
      stubLogin(
        _resp(
          bearer: 'Bearer tok',
          body: {
            'data': {
              'id': 1,
              'role': 'cashier',
              'outlet_id': 0,
            },
          },
        ),
      );
      expect(
        () => repo.login(username: 'a', password: 'p'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.invalidCredentials,
          ),
        ),
      );
    });
  });

  group('login response parsing', () {
    test('F8: reads outlet_id from login response (no extra call)', () async {
      stubLogin(
        _resp(
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

      final user = await repo.login(username: 'cashier', password: 'pw');

      expect(user.username, 'cashier');
      expect(user.role, UserRole.seller);
      verify(
        () => tokenStorage.saveSession(
          accessToken: 'token-1',
          refreshToken: 'r',
        ),
      ).called(1);
      expect(prefs.getString('username'), 'cashier');
      expect(prefs.getInt('outlet_id'), 7);
      expect(prefs.getInt('user_id'), 42);
      expect(prefs.getString('user_role'), 'cashier');
      verifyNever(
        () => apiClient.get(any<String>(), headers: any(named: 'headers')),
      );
    });

    test('F8/F10: tolerates bare object without data envelope', () async {
      stubLogin(
        _resp(
          bearer: 'Bearer t',
          body: {
            'id': 1,
            'role': 'admin',
            'outlet_id': 3,
          },
        ),
      );

      final user = await repo.login(username: 'a', password: 'b');

      expect(user.role, UserRole.admin);
      expect(prefs.getInt('outlet_id'), 3);
    });

    test('missing Authorization header maps to networkError', () async {
      stubLogin(
        _resp(
          body: {
            'data': {'role': 'admin', 'id': 1, 'outlet_id': 1},
          },
        ),
      );

      expect(
        () => repo.login(username: 'u', password: 'p'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.networkError,
          ),
        ),
      );
    });

    test('200 without parsable body maps to networkError', () async {
      stubLogin(_resp(bearer: 'Bearer t'));

      expect(
        () => repo.login(username: 'u', password: 'p'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.networkError,
          ),
        ),
      );
    });

    test('non-200 response value maps to invalidCredentials', () async {
      stubLogin(_resp(status: 401, body: {'code': 'INVALID'}));

      expect(
        () => repo.login(username: 'u', password: 'p'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.invalidCredentials,
          ),
        ),
      );
    });
  });

  group('F3: logout endpoint', () {
    test('calls POST /auth/logout before clearing local state', () async {
      final callOrder = <String>[];
      when(
        () => apiClient.post(any<String>(), data: any<dynamic>(named: 'data')),
      ).thenAnswer((_) async {
        callOrder.add('logout');
        return Response<dynamic>(
          requestOptions: RequestOptions(path: '/auth/logout'),
          statusCode: 204,
        );
      });
      when(() => tokenStorage.clear()).thenAnswer((_) async {
        callOrder.add('clear');
      });

      await repo.logout();

      expect(callOrder, ['logout', 'clear']);
      verify(() => apiClient.post('/auth/logout')).called(1);
    });

    test('swallows logout endpoint failure and still clears local state',
        () async {
      when(
        () => apiClient.post(any<String>(), data: any<dynamic>(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/logout'),
          type: DioExceptionType.connectionError,
        ),
      );

      await repo.logout();

      verify(() => tokenStorage.clear()).called(1);
    });
  });

  group('F1: invalid credentials mapping', () {
    test('DioException 401 with server error body maps to invalidCredentials',
        () async {
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
        () => repo.login(username: 'u', password: 'p'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthErrorCode.invalidCredentials,
          ),
        ),
      );
    });
  });
}
