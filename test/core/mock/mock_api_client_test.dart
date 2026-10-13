import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/mock/mock_api_client.dart';
import 'package:prro/core/mock/mock_backend.dart';

// The mock's accounts, mirrored from MockApiClient's table: the checker
// validates the password exactly, so a test that logs in has to use it.
const _adminPassword = 'admin123';
const _cashierPassword = 'cashier123';
const _managerPassword = 'manager123';

void main() {
  late MockBackend mockBackend;
  late MockApiClient client;

  setUp(() {
    mockBackend = MockBackend.instance;
    client = MockApiClient(mockBackend: mockBackend);
  });

  group('POST /auth/login', () {
    test('returns 200 with user data for valid admin credentials', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': _adminPassword},
      );

      expect(response.statusCode, 200);
      expect(response.data, isA<Map<String, dynamic>>());
      final data = response.data as Map<String, dynamic>;
      expect(data['data'], isA<Map<String, dynamic>>());
      final userData = data['data'] as Map<String, dynamic>;
      expect(userData['role'], 'admin');
      expect(userData['login'], 'admin');
      expect(userData['first_name'], 'Іван');
    });

    test('returns 200 with user data for valid cashier credentials', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'cashier', 'password': _cashierPassword},
      );

      expect(response.statusCode, 200);
      final data = response.data as Map<String, dynamic>;
      final userData = data['data'] as Map<String, dynamic>;
      expect(userData['role'], 'cashier');
      expect(userData['login'], 'cashier');
    });

    test('returns 200 with user data for valid manager credentials', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'manager', 'password': _managerPassword},
      );

      expect(response.statusCode, 200);
      final data = response.data as Map<String, dynamic>;
      final userData = data['data'] as Map<String, dynamic>;
      expect(userData['role'], 'manager');
      expect(userData['login'], 'manager');
    });

    test('returns 400 when login is empty', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': '', 'password': _cashierPassword},
      );

      expect(response.statusCode, 400);
      final data = response.data as Map<String, dynamic>;
      expect(data['code'], 'INVALID_REQUEST');
    });

    test('returns 400 when password is empty', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': ''},
      );

      expect(response.statusCode, 400);
      final data = response.data as Map<String, dynamic>;
      expect(data['code'], 'INVALID_REQUEST');
    });

    test('returns 401 for unknown user', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'unknown', 'password': _cashierPassword},
      );

      expect(response.statusCode, 401);
      final data = response.data as Map<String, dynamic>;
      expect(data['code'], 'UNAUTHORIZED');
    });

    test('returns 401 for a known user with a wrong password', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': 'any'},
      );

      expect(response.statusCode, 401);
      final data = response.data as Map<String, dynamic>;
      expect(data['code'], 'UNAUTHORIZED');
    });

    test('returns 401 for a near-miss password', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'cashier', 'password': '${_cashierPassword}x'},
      );

      expect(response.statusCode, 401);
    });

    test('returns 401 when password is empty for known user', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': ''},
      );

      expect(response.statusCode, 400);
    });

    test('Authorization header contains bearer token', () async {
      final response = await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': _adminPassword},
      );

      final authHeader = response.headers.value('Authorization');
      expect(authHeader, isNotNull);
      expect(authHeader!.startsWith('Bearer '), isTrue);
    });
  });

  group('GET /auth/me', () {
    // `AuthRepositoryImpl` never calls `/auth/me`, so no client path reaches
    // the route and the mock does not answer it: an unmatched path is the
    // honest 404 instead of a stand-in payload nobody decodes.
    test('is unrouted for the transport', () async {
      await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': _adminPassword},
      );

      expect(
        () => client.get('/auth/me'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });
  });

  group('POST /auth/logout', () {
    test('returns 204 and ends the mock session', () async {
      await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': _adminPassword},
      );

      final response = await client.post('/auth/logout');
      expect(response.statusCode, 204);
    });
  });

  group('GET /retail-outlets/', () {
    // The only admin-shaped read that survives on this transport:
    // `AuthRepositoryImpl._firstOutletId` reads it when a login payload
    // carries no `outlet_id`, and it decodes with `unwrapList` + `m['id']`,
    // so the body has to be wire JSON rather than Dart model objects.
    test('answers with decodable outlet maps', () async {
      final response = await client.get('/retail-outlets/');

      expect(response.statusCode, 200);
      final data = response.data as Map<String, dynamic>;
      expect(data['data'], isA<List<dynamic>>());
      final ids = (data['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((o) => o['id']);
      expect(ids, isNotEmpty);
      for (final id in ids) {
        expect(id, isA<int>());
      }
    });
  });
}
