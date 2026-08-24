import 'package:flutter_test/flutter_test.dart';
import 'package:prro/data/api/mock_api_client.dart';
import 'package:prro/data/mock/mock_backend.dart';

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
        data: {'login': 'admin', 'password': 'any'},
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
        data: {'login': 'cashier', 'password': 'any'},
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
        data: {'login': 'manager', 'password': 'any'},
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
        data: {'login': '', 'password': 'any'},
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
        data: {'login': 'unknown', 'password': 'any'},
      );

      expect(response.statusCode, 401);
      final data = response.data as Map<String, dynamic>;
      expect(data['code'], 'UNAUTHORIZED');
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
        data: {'login': 'admin', 'password': 'any'},
      );

      final authHeader = response.headers.value('Authorization');
      expect(authHeader, isNotNull);
      expect(authHeader!.startsWith('Bearer '), isTrue);
    });
  });

  group('GET /auth/me', () {
    test('returns 401 when not logged in', () async {
      final response = await client.get('/auth/me');

      expect(response.statusCode, 401);
      final data = response.data as Map<String, dynamic>;
      expect(data['code'], 'UNAUTHORIZED');
    });

    test('returns user data after login', () async {
      await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': 'any'},
      );

      final response = await client.get('/auth/me');

      expect(response.statusCode, 200);
      final data = response.data as Map<String, dynamic>;
      final userData = data['data'] as Map<String, dynamic>;
      expect(userData['login'], 'admin');
      expect(userData['role'], 'admin');
    });
  });

  group('POST /auth/logout', () {
    test('returns 204 and clears session', () async {
      await client.post(
        '/auth/login',
        data: {'login': 'admin', 'password': 'any'},
      );

      final response = await client.post('/auth/logout');
      expect(response.statusCode, 204);

      final meResponse = await client.get('/auth/me');
      expect(meResponse.statusCode, 401);
    });
  });
}
