import 'package:dio/dio.dart';

/// Ukrainian messages for the backend's `error.code` values
/// (`internal/app/server/response.go`).
///
/// The raw `message` for `validation_error` is Go validator text (e.g.
/// `Key: 'CategoryRequest.Name' Error:Field validation for 'Name' failed on the
/// 'min' tag`), which must never reach the UI. Unmapped codes still fall back
/// to the server's own message.
const Map<String, String> _codeMessages = {
  'not_found': 'Не знайдено.',
  'conflict': 'Такий запис уже існує.',
  'access_denied': 'Немає доступу до цього ресурсу.',
  'bad_request': 'Некоректний запит.',
  'validation_error': 'Перевірте введені дані.',
  'unauthorized': 'Невірний логін або пароль.',
  'token_error': 'Сесія прострочена. Увійдіть знову.',
  'internal_error': 'Помилка сервера.',
};

const String _genericMessage = 'Помилка сервера.';

/// A normalized API error.
///
/// The backend wraps errors as
/// `{ "error": { "code": "...", "message": "..." } }`.
/// [ApiException.fromDio] unwraps that envelope; connection/timeout failures get
/// a friendly Ukrainian message instead of a raw Dio dump.
///
/// [code] and [statusCode] are preserved because the auth and order flows
/// branch on them — only [message] is localized.
class ApiException implements Exception {
  const ApiException(this.message, {this.code, this.statusCode});

  factory ApiException.fromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] is Map) {
      final err = (data['error'] as Map).cast<String, dynamic>();
      final raw = (err['message'] ?? '').toString().trim();
      final code = err['code']?.toString();
      // `code` can be an empty string on some bind failures, so it is never
      // assumed to be present or non-empty.
      final message =
          _codeMessages[code] ?? (raw.isEmpty ? _genericMessage : raw);
      return ApiException(
        message,
        code: code,
        statusCode: e.response?.statusCode,
      );
    }
    return ApiException(_friendly(e), statusCode: e.response?.statusCode);
  }
  final String message;
  final String? code;
  final int? statusCode;

  static String _friendly(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Сервер не відповідає. Спробуйте ще раз.';

      case DioExceptionType.connectionError:
        return 'Немає зʼєднання з сервером.';

      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        final status = e.response?.statusCode;
        return status != null
            ? 'Помилка сервера ($status).'
            : 'Сталася помилка. Спробуйте ще раз.';
    }
  }

  @override
  String toString() => message;
}
