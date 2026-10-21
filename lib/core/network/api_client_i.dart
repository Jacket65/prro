import 'package:dio/dio.dart';

abstract interface class ApiClientI {
  Stream<String?> get onUnauthorized;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  });
}
