import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/admin/data/repositories/admin_outlet_repository_impl.dart';

class MockApiClient extends Mock implements ApiClientI {}

Response<dynamic> _response(
  String path,
  Object? body, {
  int status = 200,
}) => Response<dynamic>(
  requestOptions: RequestOptions(path: path),
  statusCode: status,
  data: body,
);

DioException _error(String path, int status) => DioException(
  requestOptions: RequestOptions(path: path),
  response: Response<dynamic>(
    requestOptions: RequestOptions(path: path),
    statusCode: status,
    data: {
      'error': {'code': 'not_found', 'message': 'outlet not found'},
    },
  ),
);

void main() {
  late MockApiClient apiClient;
  late AdminOutletRepositoryImpl repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = AdminOutletRepositoryImpl(apiClient);
  });

  group('fetchOutlets', () {
    test('requests the outlet list and decodes the data envelope', () async {
      when(() => apiClient.get(any<String>())).thenAnswer(
        (inv) async => _response(inv.positionalArguments.first as String, {
          'data': [
            {
              'id': 1,
              'name': 'Кав’ярня Центр',
              'address': 'вул. Хрещатик, 1',
              'city': 'Київ',
              'is_active': true,
            },
            {'id': 2, 'name': 'Кав’ярня Лівий берег'},
          ],
        }),
      );

      final outlets = await repository.fetchOutlets();

      verify(() => apiClient.get('/retail-outlets/')).called(1);
      expect(outlets, hasLength(2));
      expect(outlets.first.id, 1);
      expect(outlets.first.name, 'Кав’ярня Центр');
      expect(outlets.first.address, 'вул. Хрещатик, 1');
      expect(outlets.first.isActive, isTrue);
      // Tolerant decoding: optional fields stay null instead of throwing.
      expect(outlets[1].address, isNull);
      expect(outlets[1].city, isNull);
    });

    test('accepts a bare list (legacy/shape fallback)', () async {
      when(() => apiClient.get(any<String>())).thenAnswer(
        (inv) async => _response(inv.positionalArguments.first as String, [
          {'id': 3, 'name': 'Точка'},
        ]),
      );

      final outlets = await repository.fetchOutlets();

      expect(outlets.single.id, 3);
    });
  });

  group('error mapping', () {
    test('a 404 maps to an ApiException with the code message', () async {
      when(() => apiClient.get(any<String>())).thenThrow(_error('/retail-outlets/', 404));

      await expectLater(
        () => repository.fetchOutlets(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.code, 'code', 'not_found')
              .having((e) => e.message, 'message', 'Не знайдено.'),
        ),
      );
    });

    test('a 401 maps to an ApiException with the status', () async {
      when(() => apiClient.get(any<String>())).thenThrow(
        _error('/retail-outlets/', 401),
      );

      await expectLater(
        () => repository.fetchOutlets(),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });
  });
}
