import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/config/network_timeouts.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/security/access_token_expiry.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/core/utils/envelope.dart';
import 'package:prro/features/auth/domain/entities/auth_user.dart';
import 'package:prro/features/auth/domain/repositories/auth_repository_i.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

UserRole? _parseRole(String? roleStr) {
  return switch (roleStr) {
    'admin' => UserRole.admin,
    'manager' => UserRole.manager,
    'cashier' => UserRole.cashier,
    _ => null,
  };
}

@Singleton(as: AuthRepositoryI)
class AuthRepositoryImpl implements AuthRepositoryI {
  AuthRepositoryImpl({
    required this.tokenStorage,
    required this.apiClient,
    required this.prefs,
    required this._outlets,
    required this._talker,
  });

  final TokenStorageI tokenStorage;
  final ApiClientI apiClient;
  final Talker _talker;

  /// The session outlet: login writes it (with the outlet-list fallback below)
  /// and logout clears it, so the read side lives in one place with the write
  /// side. The rest of the login/session fields stay in prefs.
  final OutletSession _outlets;
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

    // Presence is not validity. An access token whose `exp` has passed would
    // be accepted here, enter a guarded route, and 401 on its first request —
    // tearing the session down mid-navigation instead of at restore, where the
    // app can still show the login screen cleanly. Returning `null` routes to
    // `AuthUnauthenticated(noSession)` and the initial route is already
    // `LoginRoute`, so nothing new is exposed.
    //
    // `unknown` (non-JWT mock tokens, a missing/malformed `exp`) deliberately
    // falls through to the previous presence-only behaviour: the expiry is a
    // hard signal when present, never a verdict when it is not.
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken != null &&
        checkAccessTokenExpiry(accessToken) == AccessTokenExpiry.expired) {
      return null;
    }

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
  Future<AuthUser> loginAsAdmin({String? username, String? password}) {
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
        // The timeout travels into dio's own options. A call-site
        // `.timeout(...)` would sit on top of the instance-wide 10 s
        // `receiveTimeout`, so dio would fail first and the manual wrapper
        // would never be the thing that fires.
        response = await apiClient.post(
          '/auth/login',
          data: {'login': username, 'password': password},
          timeout: NetworkTimeouts.auth,
        );
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
      final refreshToken = refresh is String && refresh.isNotEmpty
          ? refresh
          : null;
      var outletId = data['outlet_id'] is int ? data['outlet_id'] as int : null;

      // The backend does not (yet) return `outlet_id` in the login payload.
      // Fall back to the user-scoped outlet list, authenticated with the
      // access token we just received (the session is persisted below, so the
      // `Authorization` header must be overridden explicitly here). Reading
      // the login body first keeps a future backend fix (a real `outlet_id`)
      // authoritative automatically.
      if (outletId == null || outletId == 0) {
        outletId = await _firstOutletId(token);
      }

      // No outlet could be resolved from login or the outlet list → the user
      // has no outlet assignment; treat as invalid credentials.
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
      await _outlets.set(outletId);
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

  /// Resolves the first outlet visible to the freshly-logged-in user via
  /// `GET /retail-outlets/` (the list is user-scoped server-side).
  ///
  /// Returns `null` when the list is empty or the call fails for any reason;
  /// the caller maps that to [AuthErrorCode.invalidCredentials].
  Future<int?> _firstOutletId(String accessToken) async {
    try {
      final response = await apiClient.get(
        '/retail-outlets/',
        headers: {'Authorization': 'Bearer $accessToken'},
        timeout: NetworkTimeouts.auth,
      );
      final ids = unwrapList<int?>(
        response.data,
        (m) => m['id'] is int ? m['id'] as int : null,
      );
      for (final id in ids) {
        if (id != null && id != 0) return id;
      }
      return null;
    } on Object {
      return null;
    }
  }

  Future<void> _doLogout() async {
    try {
      await apiClient.post('/auth/logout');
    } on Object catch (e) {
      _talker.warning(
        '[AUTH] logout endpoint failed (swallowed): $e',
      );
    }
    await tokenStorage.clear();
    await prefs.remove('username');
    await _outlets.clear();
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
