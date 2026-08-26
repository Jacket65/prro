import 'dart:async';
import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
import 'package:prro/data/services/login_service_i.dart';
import 'package:prro/features/auth/model/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserRole? _parseRole(String? roleStr) {
  return switch (roleStr) {
    'admin' => UserRole.admin,
    'manager' => UserRole.manager,
    'cashier' => UserRole.seller,
    _ => null,
  };
}

@Environment('mock')
@Singleton(as: AuthRepositoryI)
class AuthRepositoryMock implements AuthRepositoryI {
  AuthRepositoryMock({
    required this.loginService,
    required this.tokenStorage,
    required this.apiClient,
    required this.prefs,
  });

  final LoginServiceI loginService;
  final TokenStorageI tokenStorage;
  final ApiClientI apiClient;
  final SharedPreferences prefs;

  Completer<void>? _mutex;

  Future<T> _serialized<T>(Future<T> Function() operation) async {
    while (_mutex != null) {
      await _mutex!.future;
    }
    final completer = Completer<void>();
    _mutex = completer;
    try {
      return await operation();
    } finally {
      _mutex = null;
      completer.complete();
    }
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final valid = await tokenStorage.hasValidSession();
    if (!valid) return null;

    final username = prefs.getString('username');
    if (username == null || username.isEmpty) return null;

    final role = _parseRole(prefs.getString('user_role'));
    if (role == null) return null;

    return AuthUser(username: username, role: role);
  }

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) => _serialized(() => _doLogin(username: username, password: password));

  @override
  Future<void> logout() => _serialized(_doLogout);

  @override
  Future<AuthUser> loginAsAdmin({
    String? username,
    String? password,
  }) {
    return _serialized(() async {
      final user = username != null && password != null
          ? await _doLogin(username: username, password: password)
          : await _readCurrentUser();

      if (user.role == UserRole.admin || user.role == UserRole.manager) {
        return user;
      }

      if (username != null && password != null) {
        await _doLogout();
      }

      throw const AuthException(AuthErrorCode.insufficientRole);
    });
  }

  Future<AuthUser> _doLogin({
    required String username,
    required String password,
  }) async {
    try {
      final result = await loginService
          .login(username: username, password: password)
          .timeout(const Duration(seconds: 15));

      if (result.accessToken.isEmpty) {
        throw const AuthException(AuthErrorCode.invalidCredentials);
      }

      if (result.outletId == null || result.outletId == 0) {
        throw const AuthException(AuthErrorCode.invalidCredentials);
      }

      final role = _parseRole(result.role);
      if (role == null) {
        throw const AuthException(AuthErrorCode.invalidCredentials);
      }

      await tokenStorage.saveSession(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await prefs.setString('username', username);
      await prefs.setInt('outlet_id', result.outletId!);
      if (result.role != null) {
        await prefs.setString('user_role', result.role!);
      }
      if (result.userId != null) {
        await prefs.setInt('user_id', result.userId!);
      }

      return AuthUser(username: username, role: role);
    } on AuthException {
      rethrow;
    } on ApiException catch (e) {
      final status = e.statusCode;
      if (status == 401 || status == 400) {
        throw const AuthException(AuthErrorCode.invalidCredentials);
      }
      throw const AuthException(AuthErrorCode.networkError);
    } on TimeoutException {
      throw const AuthException(AuthErrorCode.networkError);
    } on Object {
      throw const AuthException(AuthErrorCode.networkError);
    }
  }

  Future<void> _doLogout() async {
    try {
      await apiClient.post('/auth/logout');
    } on Object catch (e) {
      developer.log(
        '[AUTH] logout endpoint failed (swallowed): $e',
        name: 'auth',
      );
    }
    await tokenStorage.clear();
    await prefs.remove('username');
    await prefs.remove('outlet_id');
    await prefs.remove('user_role');
    await prefs.remove('user_id');
  }

  Future<AuthUser> _readCurrentUser() async {
    final username = prefs.getString('username');
    if (username == null || username.isEmpty) {
      throw const AuthException(AuthErrorCode.sessionRestoreFailed);
    }
    final role = _parseRole(prefs.getString('user_role'));
    if (role == null) {
      throw const AuthException(AuthErrorCode.sessionRestoreFailed);
    }
    return AuthUser(username: username, role: role);
  }
}
