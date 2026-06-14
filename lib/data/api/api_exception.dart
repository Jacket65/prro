import 'package:dio/dio.dart';

/// A normalized API error.
///
/// The backend wraps errors as `{ "error": { "code": "...", "message": "..." } }`.
/// [ApiException.fromDio] unwraps that envelope; connection/timeout failures get
/// a friendly Ukrainian message instead of a raw Dio dump.
class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const ApiException(this.message, {this.code, this.statusCode});

  factory ApiException.fromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] is Map) {
      final err = (data['error'] as Map).cast<String, dynamic>();
      final msg = (err['message'] ?? '').toString();
      return ApiException(
        msg.isEmpty ? 'Помилка сервера.' : msg,
        code: err['code']?.toString(),
        statusCode: e.response?.statusCode,
      );
    }
    return ApiException(_friendly(e), statusCode: e.response?.statusCode);
  }

  static String _friendly(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Сервер не відповідає. Спробуйте ще раз.';
      case DioExceptionType.connectionError:
        return 'Немає зʼєднання з сервером.';
      default:
        final status = e.response?.statusCode;
        return status != null
            ? 'Помилка сервера ($status).'
            : 'Сталася помилка. Спробуйте ще раз.';
    }
  }

  @override
  String toString() => message;
}

/// Wraps any error thrown by the Dio layer into an [ApiException].
ApiException asApiException(Object e) =>
    e is DioException ? ApiException.fromDio(e) : ApiException(e.toString());
