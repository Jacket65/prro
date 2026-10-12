import 'package:dio/dio.dart';

/// HTTP surface of the app.
///
/// Every verb takes an optional [Duration] `timeout` that bounds that single
/// request, overriding the client's default connect/receive timeout. Omit it
/// to keep the default (`NetworkTimeouts.standard`) — an unannotated call is
/// unaffected by this parameter existing.
///
/// The bound has to travel *down* to dio: a call-site `.timeout()` sits on top
/// of dio's own `receiveTimeout`, so when the default is smaller dio fails
/// first and the manual wrapper is dead code. Mock transports accept and
/// ignore the parameter (they have no network).
abstract interface class ApiClientI {
  /// Emits when the session can no longer be recovered (refresh failed): the
  /// app should clear state and return to the login screen.
  ///
  /// The emitted value is the access token that failed to refresh (or `null`
  /// if it was already cleared). Consumers can use this to correlate the
  /// expiry with a specific session and avoid clobbering a newer one.
  Stream<String?> get onUnauthorized;

  /// GET with optional query parameters, cancel token, and per-request headers.
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  /// POST. State-changing POSTs require an `Idempotency-Key`; pass
  /// [idempotencyKey] to use a stable one. Per-request [headers] are merged
  /// into the request options and override default headers.
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  /// PATCH. Same idempotency rules as [post].
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  /// PUT. Same idempotency rules as [post].
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  /// DELETE. [data] is rarely sent, but allowed (some backends read a body).
  /// State-changing deletes may pass an [idempotencyKey].
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });
}
