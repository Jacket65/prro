import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/repositories/admin_unwrap.dart';
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart';
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

@Singleton(as: AuthRepositoryI)
class AuthRepositoryImpl implements AuthRepositoryI {
  AuthRepositoryImpl({
    required this.tokenStorage,
    required this.apiClient,
    required this.prefs,
  });

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
  }) =>
      _serialized(() => _doLogin(username: username, password: password));

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
      final Response<dynamic> response;
      try {
        response = await apiClient
            .post(
              '/auth/login',
              data: {'login': username, 'password': password},
            )
            .timeout(const Duration(seconds: 15));
      } on DioException catch (e) {
        throw ApiException.fromDio(e);
      }

      if (response.statusCode != 200) {
        throw const ApiException(
          "Невірне ім'я користувача або пароль",
          code: 'INVALID_CREDENTIALS',
          statusCode: 401,
        );
      }

      final authHeader = response.headers.value('Authorization');
      if (authHeader == null ||
          !authHeader.toLowerCase().startsWith('bearer ')) {
        throw const ApiException(
          'Сервер повернув неочікувану відповідь.',
          code: 'MISSING_ACCESS_TOKEN',
          statusCode: 200,
        );
      }
      final token = authHeader.substring(7).trim();
      if (token.isEmpty) {
        throw const ApiException(
          'Сервер повернув неочікувану відповідь.',
          code: 'MISSING_ACCESS_TOKEN',
          statusCode: 200,
        );
      }

      final data = unwrapObject<Map<String, dynamic>>(response.data, (m) => m);
      if (data == null) {
        throw const ApiException(
          'Сервер повернув неочікувану відповідь.',
          code: 'INVALID_PAYLOAD',
          statusCode: 200,
        );
      }

      final role = data['role'] is String ? data['role'] as String : null;
      final userId = data['id'] is int ? data['id'] as int : null;
      final refresh = data['refresh_token'];
      final refreshToken =
          refresh is String && refresh.isNotEmpty ? refresh : null;
      final outletId =
          data['outlet_id'] is int ? data['outlet_id'] as int : null;

      if (outletId == null || outletId == 0) {
        throw const AuthException(AuthErrorCode.invalidCredentials);
      }

      final parsedRole = _parseRole(role);
      if (parsedRole == null) {
        throw const AuthException(AuthErrorCode.invalidCredentials);
      }

      await tokenStorage.saveSession(
        accessToken: token,
        refreshToken: refreshToken,
      );
      await prefs.setString('username', username);
      await prefs.setInt('outlet_id', outletId);
      if (role != null) {
        await prefs.setString('user_role', role);
      }
      if (userId != null) {
        await prefs.setInt('user_id', userId);
      }

      return AuthUser(username: username, role: parsedRole);
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
