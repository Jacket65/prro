import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/admin/data/models/admin_user.dart';
import 'package:prro/features/admin/data/repositories/admin_user_repository_impl.dart';

class MockApiClient extends Mock implements ApiClientI {}

Response<dynamic> _response(String path, Object? body) => Response<dynamic>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: body,
);

DioException _error(String path, int status) => DioException(
  requestOptions: RequestOptions(path: path),
  response: Response<dynamic>(
    requestOptions: RequestOptions(path: path),
    statusCode: status,
    data: {
      'error': {'code': 'access_denied', 'message': 'no rights for this'},
    },
  ),
);

void main() {
  late MockApiClient apiClient;
  late AdminUserRepositoryImpl repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = AdminUserRepositoryImpl(apiClient);
  });

  group('fetchUsers', () {
    test(
      'requests the outlet-scoped users and decodes the data envelope',
      () async {
        when(() => apiClient.get(any<String>())).thenAnswer(
          (inv) async => _response(inv.positionalArguments.first as String, {
            'data': [
              {
                'id': 1,
                'first_name': 'Іван',
                'last_name': 'Петренко',
                'phone': '+380931112233',
                'email': 'ivan@example.com',
                'status': 'active',
                'role': 'cashier',
              },
            ],
          }),
        );

        final users = await repository.fetchUsers(outletId: 7);

        verify(() => apiClient.get('/retail-outlets/7/users')).called(1);
        final user = users.single;
        expect(user.id, 1);
        // The name resolves from the split first/last name fields.
        expect(user.name, 'Іван Петренко');
        expect(user.status, DpsStatus.active);
        expect(user.role, 'cashier');
      },
    );

    test('falls back to the login when no name fields are sent', () async {
      when(() => apiClient.get(any<String>())).thenAnswer(
        (inv) async => _response(inv.positionalArguments.first as String, {
          'data': [
            {'id': 2, 'login': 'cashier2', 'status': 'registered'},
          ],
        }),
      );

      final users = await repository.fetchUsers(outletId: 7);

      expect(users.single.name, 'cashier2');
      expect(users.single.status, DpsStatus.registered);
    });

    test('a legacy capitalized status still maps to its value', () async {
      when(() => apiClient.get(any<String>())).thenAnswer(
        (inv) async => _response(inv.positionalArguments.first as String, {
          'data': [
            {'id': 3, 'login': 'a', 'status': 'Active'},
          ],
        }),
      );

      final users = await repository.fetchUsers(outletId: 7);

      // The status converter lowercases before mapping.
      expect(users[0].status, DpsStatus.active);
    });

    test(
      'a genuinely unknown status maps to unknown, a missing one to null',
      () async {
        when(() => apiClient.get(any<String>())).thenAnswer(
          (inv) async => _response(inv.positionalArguments.first as String, {
            'data': [
              {'id': 3, 'login': 'a', 'status': 'frozen'},
              {'id': 4, 'login': 'b'},
            ],
          }),
        );

        final users = await repository.fetchUsers(outletId: 7);

        expect(users[0].status, DpsStatus.unknown);
        expect(users[1].status, isNull);
      },
    );
  });

  group('error mapping', () {
    test(
      'a 403 maps to an ApiException with the mapped code message',
      () async {
        when(
          () => apiClient.get(any<String>()),
        ).thenThrow(_error('/retail-outlets/7/users', 403));

        await expectLater(
          () => repository.fetchUsers(outletId: 7),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 403)
                .having(
                  (e) => e.message,
                  'message',
                  'Немає доступу до цього ресурсу.',
                ),
          ),
        );
      },
    );

    test('a 500 maps to an ApiException with the status', () async {
      when(
        () => apiClient.get(any<String>()),
      ).thenThrow(_error('/retail-outlets/7/users', 500));

      await expectLater(
        () => repository.fetchUsers(outletId: 7),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });
}
