import 'package:dio/dio.dart';

abstract interface class ApiClientI {
  /// Emits when the session can no longer be recovered (refresh failed): the
  /// app should clear state and return to the login screen.
  Stream<void> get onUnauthorized;

  /// GET with optional query parameters and a [cancelToken] (so an in-flight
  /// request can be aborted, e.g. superseded search input).
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  /// POST. State-changing POSTs require an `Idempotency-Key`; pass
  /// [idempotencyKey] to use a stable one (e.g. generated when a payment modal
  /// opens). If omitted, the client auto-generates one per request.
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
  });

  /// PATCH. Same idempotency rules as [post].
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
  });

  /// PUT. Same idempotency rules as [post].
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
  });

  /// DELETE. [data] is rarely sent, but allowed (some backends read a body).
  /// State-changing deletes may pass an [idempotencyKey].
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
  });
}
