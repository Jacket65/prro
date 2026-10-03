import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/network/api_exception.dart';

DioException _dioError({
  required int status,
  required Object? body,
  String path = '/some-path',
}) {
  return DioException(
    requestOptions: RequestOptions(path: path),
    response: Response<dynamic>(
      requestOptions: RequestOptions(path: path),
      statusCode: status,
      data: body,
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  group('ApiException.fromDio envelope', () {
    test('unwraps {data,error,meta} and keeps code + statusCode', () {
      final exception = ApiException.fromDio(
        _dioError(
          status: 404,
          body: {
            'data': null,
            'error': {'code': 'not_found', 'message': 'order not found'},
            'meta': {'request_id': 'abc-123'},
          },
        ),
      );

      expect(exception.code, 'not_found');
      expect(exception.statusCode, 404);
      expect(exception.message, 'Не знайдено.');
    });

    test('survives an envelope without meta (non-release build)', () {
      final exception = ApiException.fromDio(
        _dioError(
          status: 400,
          body: {
            'error': {'code': 'bad_request', 'message': 'ignored'},
          },
        ),
      );

      expect(exception.message, 'Некоректний запит.');
      expect(exception.statusCode, 400);
    });
  });

  group('ApiException.fromDio code mapping', () {
    const goValidatorText =
        "Key: 'CategoryRequest.Name' Error:Field validation for 'Name' "
        "failed on the 'min' tag";

    test('maps every backend error code to a Ukrainian message', () {
      const codes = {
        'not_found',
        'conflict',
        'access_denied',
        'bad_request',
        'validation_error',
        'unauthorized',
        'token_error',
        'internal_error',
      };

      for (final code in codes) {
        final exception = ApiException.fromDio(
          _dioError(
            status: 400,
            body: {
              'error': {'code': code, 'message': goValidatorText},
            },
          ),
        );

        expect(
          exception.message,
          isNot(goValidatorText),
          reason: 'raw Go text must not leak for "$code"',
        );
        expect(exception.message, isNotEmpty);
        expect(exception.code, code);
      }
    });

    test('validation_error never surfaces the Go validator text', () {
      final exception = ApiException.fromDio(
        _dioError(
          status: 400,
          body: {
            'error': {'code': 'validation_error', 'message': goValidatorText},
          },
        ),
      );

      expect(exception.message, 'Перевірте введені дані.');
    });

    test('unauthorized and token_error stay distinguishable by code', () {
      final unauthorized = ApiException.fromDio(
        _dioError(
          status: 401,
          body: {
            'error': {'code': 'unauthorized', 'message': 'bad credentials'},
          },
        ),
      );
      final tokenError = ApiException.fromDio(
        _dioError(
          status: 401,
          body: {
            'error': {'code': 'token_error', 'message': 'token expired'},
          },
        ),
      );

      expect(unauthorized.code, 'unauthorized');
      expect(tokenError.code, 'token_error');
      expect(unauthorized.message, isNot(tokenError.message));
    });

    test('an unmapped code falls back to the server message', () {
      final exception = ApiException.fromDio(
        _dioError(
          status: 418,
          body: {
            'error': {'code': 'teapot', 'message': 'Я чайник'},
          },
        ),
      );

      expect(exception.message, 'Я чайник');
      expect(exception.code, 'teapot');
    });
  });

  group('ApiException.fromDio empty body', () {
    test('empty code + message yields a generic message without crashing', () {
      final exception = ApiException.fromDio(
        _dioError(
          status: 400,
          body: {
            'error': {'code': '', 'message': ''},
          },
        ),
      );

      expect(exception.message, 'Помилка сервера.');
      expect(exception.statusCode, 400);
    });

    test('a null error object yields a generic message', () {
      final exception = ApiException.fromDio(
        _dioError(status: 400, body: {'error': null}),
      );

      expect(exception.message, isNotEmpty);
    });

    test('no response body at all falls back to the Dio message', () {
      final exception = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/some-path'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(exception.message, 'Немає зʼєднання з сервером.');
      expect(exception.statusCode, isNull);
    });
  });

  test('toString returns the localized message', () {
    expect(
      const ApiException('Помилка сервера.').toString(),
      'Помилка сервера.',
    );
  });
}
