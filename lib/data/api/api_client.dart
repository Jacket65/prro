import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:prro/config/env.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/data/api/api_client_i.dart';

class ApiClient implements ApiClientI {
  ApiClient({required this.dio, required this.tokenStorage})
    : _refreshDio = Dio(BaseOptions(baseUrl: Env.baseUrl)) {
    dio.options.baseUrl = Env.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    _initializeInterceptors();
  }

  final Dio dio;

  final TokenStorageI tokenStorage;

  final Dio _refreshDio;

  Future<bool>? _refreshFuture;

  /// Synchronous re-entry guard for the auth-failure teardown. Checked and set
  /// with no `await` in between, so concurrent 401s cannot all pass the guard
  /// before any of them sets it (the async token reads would otherwise yield
  /// and let multiple callers through).
  bool _teardownInProgress = false;

  final StreamController<String?> _unauthorized =
      StreamController<String?>.broadcast();

  @override
  Stream<String?> get onUnauthorized => _unauthorized.stream;

  void _initializeInterceptors() {
    dio.interceptors.clear();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            _teardownInProgress = false;
            if (!options.headers.containsKey('Authorization')) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
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
                final token = await tokenStorage.getAccessToken();
                if (token != null && token.isNotEmpty) {
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $token';
                }
                final cloned = await dio.fetch<dynamic>(
                  error.requestOptions,
                );
                return handler.resolve(cloned);
              } on DioException catch (retryError) {
                return handler.next(retryError);
              }
            } else {
              await onAuthFailure();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() {
    return _refreshFuture ??= _doRefresh().whenComplete(
      () => _refreshFuture = null,
    );
  }

  Future<bool> _doRefresh() async {
    final refresh = await tokenStorage.getRefreshToken();
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
          await tokenStorage.saveAccessToken(token);
          _teardownInProgress = false;
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

  Future<void> onAuthFailure() async {
    if (_teardownInProgress) return;
    _teardownInProgress = true;
    final accessToken = await tokenStorage.getAccessToken();
    final refreshToken = await tokenStorage.getRefreshToken();
    final hadSession =
        (accessToken != null && accessToken.isNotEmpty) ||
        (refreshToken != null && refreshToken.isNotEmpty);
    if (!hadSession) {
      _teardownInProgress = false;
      return;
    }
    await tokenStorage.clear();
    log('[AUTH] session cleared — redirecting to login');
    if (!_unauthorized.isClosed) _unauthorized.add(accessToken);
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    return dio.get(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: _mergeHeaders(null, headers),
    );
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  }) {
    return dio.post(
      path,
      data: data,
      options: _mergeHeaders(idempotencyKey, headers),
    );
  }

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  }) {
    return dio.patch(
      path,
      data: data,
      options: _mergeHeaders(idempotencyKey, headers),
    );
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  }) {
    return dio.put(
      path,
      data: data,
      options: _mergeHeaders(idempotencyKey, headers),
    );
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  }) {
    return dio.delete(
      path,
      data: data,
      options: _mergeHeaders(idempotencyKey, headers),
    );
  }

  Options? _mergeHeaders(
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  ) {
    final map = <String, dynamic>{};
    if (idempotencyKey != null) {
      map['Idempotency-Key'] = idempotencyKey;
    }
    if (headers != null) {
      map.addAll(headers);
    }
    return map.isEmpty ? null : Options(headers: map);
  }
}
