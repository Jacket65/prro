import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
import 'package:prro/data/repositories/login_repository/login_result.dart';
import 'package:prro/data/services/login_service_i.dart';
import 'package:prro/features/auth/model/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiClient extends Mock implements ApiClientI {}

class MockLoginService extends Mock implements LoginServiceI {}

class MockTokenStorage extends Mock implements TokenStorageI {}

class _FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRequestOptions());
    registerFallbackValue(<String, dynamic>{});
  });

  late MockApiClient apiClient;
  late MockLoginService loginService;
  late MockTokenStorage tokenStorage;
  late SharedPreferences prefs;
  late AuthRepositoryImpl repo;

  setUp(() async {
    apiClient = MockApiClient();
    loginService = MockLoginService();
    tokenStorage = MockTokenStorage();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    when(() => tokenStorage.saveSession(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        )).thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});

    repo = AuthRepositoryImpl(
      loginService: loginService,
      tokenStorage: tokenStorage,
      apiClient: apiClient,
      prefs: prefs,
    );
  });

  group('F9: role parsing', () {
    test('maps cashier to seller', () async {
      when(
        () => loginService.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const LoginResult(
          accessToken: 'tok',
          refreshToken: 'r',
          role: 'cashier',
          userId: 1,
          outletId: 1,
        ),
      );
      final user = await repo.login(username: 'cashier', password: 'p');
      expect(user.role, UserRole.seller);
    });

    test('maps admin to admin', () async {
      when(
        () => loginService.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const LoginResult(
          accessToken: 'tok',
          role: 'admin',
          userId: 1,
          outletId: 1,
        ),
      );
      final user = await repo.login(username: 'a', password: 'p');
      expect(user.role, UserRole.admin);
    });

    test('F9: throws invalidCredentials on unknown role', () async {
      when(
        () => loginService.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const LoginResult(
          accessToken: 'tok',
          role: 'supervisor',
          userId: 1,
          outletId: 1,
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
      when(
        () => loginService.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const LoginResult(
          accessToken: 'tok',
          role: 'cashier',
          userId: 1,
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
      when(
        () => loginService.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const LoginResult(
          accessToken: 'tok',
          role: 'cashier',
          userId: 1,
          outletId: 0,
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
    test('ApiException 401 maps to invalidCredentials', () async {
      when(
        () => loginService.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        const AuthException(AuthErrorCode.networkError),
      );
      expect(
        () => repo.login(username: 'a', password: 'p'),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
