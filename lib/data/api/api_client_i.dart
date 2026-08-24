import 'package:dio/dio.dart';

abstract interface class ApiClientI {
  /// Emits when the session can no longer be recovered (refresh failed): the
  /// app should clear state and return to the login screen.
  Stream<void> get onUnauthorized;

  /// GET with optional query parameters, cancel token, and per-request headers.
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  });

  /// POST. State-changing POSTs require an `Idempotency-Key`; pass
  /// [idempotencyKey] to use a stable one. Per-request [headers] are merged
  /// into the request options and override default headers.
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  });

  /// PATCH. Same idempotency rules as [post].
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  });

  /// PUT. Same idempotency rules as [post].
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  });

  /// DELETE. [data] is rarely sent, but allowed (some backends read a body).
  /// State-changing deletes may pass an [idempotencyKey].
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
  });
}
