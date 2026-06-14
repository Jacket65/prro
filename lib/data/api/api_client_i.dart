import 'package:dio/dio.dart';

abstract interface class ApiClientI {
  /// Emits when the session can no longer be recovered (refresh failed): the
  /// app should clear state and return to the login screen.
  Stream<void> get onUnauthorized;

  /// GET with optional query parameters and a [cancelToken] (so an in-flight
  /// request can be aborted, e.g. superseded search input).
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  /// POST. State-changing POSTs require an `Idempotency-Key`; pass
  /// [idempotencyKey] to use a stable one (e.g. generated when a payment modal
  /// opens). If omitted, the client auto-generates one per request.
  Future<Response> post(String path, {dynamic data, String? idempotencyKey});

  /// PATCH. Same idempotency rules as [post].
  Future<Response> patch(String path, {dynamic data, String? idempotencyKey});
}
