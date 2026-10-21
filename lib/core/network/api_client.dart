import 'dart:async';
import 'package:dio/dio.dart';
import 'package:prro/core/config/env.dart';
import 'package:prro/core/logging/app_talker.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/payload_log.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class ApiClient implements ApiClientI {
  ApiClient({required this.dio, required this.tokenStorage, Talker? talker})
    : _talker = talker ?? appTalker,
      _refreshDio = Dio(BaseOptions(baseUrl: Env.baseUrl)) {
    dio.options
      ..baseUrl = Env.baseUrl
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 10);
    _initializeInterceptors();
  }

  final Dio dio;
  final TokenStorageI tokenStorage;
  final Talker _talker;
  final Dio _refreshDio;

  Future<bool>? _refreshFuture;
  bool _teardownInProgress = false;

  final StreamController<String?> _unauthorized =
      StreamController<String?>.broadcast();

  @override
  Stream<String?> get onUnauthorized => _unauthorized.stream;

  void _initializeInterceptors() {
    dio.interceptors
      ..clear()
      ..add(TalkerDioLogger(talker: _talker))
      ..add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await tokenStorage.getAccessToken();
            if (token != null && token.isNotEmpty) {
              _teardownInProgress = false;
              options.headers.putIfAbsent(
                'Authorization',
                () => 'Bearer $token',
              );
            }
            options.headers
              ..putIfAbsent('Accept', () => 'application/json')
              ..putIfAbsent('Content-Type', () => 'application/json');

            final requestBody = describePayload(options.data);
            if (requestBody != null) {
              _talker.debug('[REQUEST BODY] $requestBody');
            }

            return handler.next(options);
          },
          onError: (error, handler) async {
            final status = error.response?.statusCode;
            final errorBody = describePayload(error.response?.data);
            if (errorBody != null) _talker.error('[ERROR BODY] $errorBody');

            final path = error.requestOptions.path;
            final isAuthCall =
                path.contains('/auth/login') || path.contains('/auth/refresh');
            final canRetry =
                status == 401 &&
                error.requestOptions.extra['__retried__'] != true &&
                !isAuthCall;

            if (canRetry) {
              if (await _refreshToken()) {
                try {
                  error.requestOptions.extra['__retried__'] = true;
                  final token = await tokenStorage.getAccessToken();
                  if (token != null && token.isNotEmpty) {
                    error.requestOptions.headers['Authorization'] =
                        'Bearer $token';
                  }
                  return handler.resolve(
                    await dio.fetch<dynamic>(error.requestOptions),
                  );
                } on DioException catch (retryError) {
                  return handler.next(retryError);
                }
              }
              await onAuthFailure();
            }
            return handler.next(error);
          },
        ),
      );
  }

  Future<bool> _refreshToken() =>
      _refreshFuture ??= _doRefresh().whenComplete(() => _refreshFuture = null);

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
          _talker.info('[AUTH] access token refreshed');
          return true;
        }
      }
      return false;
    } on DioException catch (e) {
      _talker.warning('[AUTH] refresh failed: ${e.response?.statusCode}');
      return false;
    }
  }

  Future<void> onAuthFailure() async {
    if (_teardownInProgress) return;
    _teardownInProgress = true;

    final accessToken = await tokenStorage.getAccessToken();
    final refreshToken = await tokenStorage.getRefreshToken();
    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty)) {
      _teardownInProgress = false;
      return;
    }

    await tokenStorage.clear();
    _talker.warning('[AUTH] session cleared — redirecting to login');
    if (!_unauthorized.isClosed) _unauthorized.add(accessToken);
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) => _request(
    'GET',
    path,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
    headers: headers,
    timeout: timeout,
  );

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) => _request(
    'POST',
    path,
    data: data,
    idempotencyKey: idempotencyKey,
    headers: headers,
    timeout: timeout,
  );

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) => _request(
    'PATCH',
    path,
    data: data,
    idempotencyKey: idempotencyKey,
    headers: headers,
    timeout: timeout,
  );

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) => _request(
    'PUT',
    path,
    data: data,
    idempotencyKey: idempotencyKey,
    headers: headers,
    timeout: timeout,
  );

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) => _request(
    'DELETE',
    path,
    data: data,
    idempotencyKey: idempotencyKey,
    headers: headers,
    timeout: timeout,
  );

  Future<Response<dynamic>> _request(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) {
    return dio.request<dynamic>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: Options(
        method: method,
        headers: {'Idempotency-Key': ?idempotencyKey, ...?headers},
        connectTimeout: timeout,
        receiveTimeout: timeout,
      ),
    );
  }
}
