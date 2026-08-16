import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:prro/config/env.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient implements ApiClientI {
  ApiClient({required this._dio, required this._prefs})
    : _refreshDio = Dio(BaseOptions(baseUrl: Env.baseUrl)) {
    _dio.options.baseUrl = Env.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _initializeInterceptors();
  }
  final Dio _dio;
  final SharedPreferences _prefs;

  /// Bare Dio (no interceptors) used only to call `/auth/refresh`, so a 401 on
  /// refresh can't recurse back into the refresh logic.
  final Dio _refreshDio;

  /// In-flight refresh, shared by all callers (single-flight): concurrent 401s
  /// await one refresh instead of each firing its own.
  Future<bool>? _refreshFuture;

  final StreamController<void> _unauthorized =
      StreamController<void>.broadcast();

  @override
  Stream<void> get onUnauthorized => _unauthorized.stream;

  void _initializeInterceptors() {
    _dio.interceptors.clear();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          // NOTE: Idempotency-Key is set per-call by the caller (see post/patch
          // `idempotencyKey`), not auto-generated here — the key must be stable
          // across a logical action and its retries.
          log(
            '[REQUEST] ${options.method} ${options.baseUrl} ${options.path}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log(
            '[RESPONSE] ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode;
          log('[ERROR] $status ${error.requestOptions.path} ${error.message}');

          final isAuthCall =
              error.requestOptions.path.contains('/auth/login') ||
              error.requestOptions.path.contains('/auth/refresh');
          final canRetry =
              status == 401 &&
              error.requestOptions.extra['__retried__'] != true &&
              !isAuthCall;

          if (canRetry) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              try {
                error.requestOptions.extra['__retried__'] = true;
                final token = _prefs.getString('auth_token');
                if (token != null && token.isNotEmpty) {
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $token';
                }
                final cloned = await _dio.fetch<dynamic>(
                  error.requestOptions,
                );
                return handler.resolve(cloned);
              } on DioException catch (retryError) {
                return handler.next(retryError);
              }
            } else {
              // Refresh impossible/failed → session is dead.
              await _onAuthFailure();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Exchanges the refresh token for a fresh access token. Single-flight: a
  /// concurrent caller reuses the in-flight refresh. `POST /auth/refresh`
  /// returns 204 with the new access token in the `Authorization` header.
  Future<bool> _refreshToken() {
    return _refreshFuture ??= _doRefresh().whenComplete(
      () => _refreshFuture = null,
    );
  }

  Future<bool> _doRefresh() async {
    final refresh = _prefs.getString('refresh_token');
    if (refresh == null || refresh.isEmpty) return false;
    try {
      final response = await _refreshDio.post<dynamic>(
        '/auth/refresh',
        data: {'refresh_token': refresh},
      );
      final authHeader = response.headers.value('Authorization');
      if (authHeader != null &&
          authHeader.toLowerCase().startsWith('bearer ')) {
        final token = authHeader.substring(7).trim();
        if (token.isNotEmpty) {
          await _prefs.setString('auth_token', token);
          log('[AUTH] access token refreshed');
          return true;
        }
      }
      return false;
    } on DioException catch (e) {
      log('[AUTH] refresh failed: ${e.response?.statusCode}');
      return false;
    }
  }

  /// Clears the session and notifies listeners once
  /// (concurrent 401s collapse to a single logout/redirect).
  Future<void> _onAuthFailure() async {
    final hadSession =
        (_prefs.getString('auth_token') ?? '').isNotEmpty ||
        (_prefs.getString('refresh_token') ?? '').isNotEmpty;
    if (!hadSession) return;
    await _prefs.remove('auth_token');
    await _prefs.remove('refresh_token');
    await _prefs.setBool('isLogged', false);
    log('[AUTH] session cleared — redirecting to login');
    if (!_unauthorized.isClosed) _unauthorized.add(null);
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
  }) {
    return _dio.post(
      path,
      data: data,
      options: _idempotentOptions(idempotencyKey),
    );
  }

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
  }) {
    return _dio.patch(
      path,
      data: data,
      options: _idempotentOptions(idempotencyKey),
    );
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
  }) {
    return _dio.put(
      path,
      data: data,
      options: _idempotentOptions(idempotencyKey),
    );
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
  }) {
    return _dio.delete(
      path,
      data: data,
      options: _idempotentOptions(idempotencyKey),
    );
  }

  Options? _idempotentOptions(String? key) =>
      key == null ? null : Options(headers: {'Idempotency-Key': key});
}
