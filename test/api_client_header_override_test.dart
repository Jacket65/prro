import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/data/api/api_client.dart';

class MockTokenStorage extends Mock implements TokenStorageI {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  late ApiClient apiClient;
  late MockHttpClientAdapter adapter;
  late MockTokenStorage tokenStorage;

  setUp(() {
    tokenStorage = MockTokenStorage();
    when(() => tokenStorage.getAccessToken()).thenAnswer(
      (_) async => 'default-token',
    );
    when(() => tokenStorage.getRefreshToken()).thenAnswer(
      (_) async => 'some-refresh',
    );
    when(() => tokenStorage.hasValidSession()).thenAnswer((_) async => true);
    when(() => tokenStorage.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});

    adapter = MockHttpClientAdapter();
    when(
      () => adapter.fetch(any(), any(), any()),
    ).thenAnswer(
      (invocation) async {
        final options = invocation.positionalArguments[0] as RequestOptions;
        return ResponseBody.fromString(
          '{"received":"${options.headers['Authorization']}"}',
          200,
          headers: {
            'content-type': ['application/json'],
          },
        );
      },
    );

    final dio = Dio()..httpClientAdapter = adapter;
    apiClient = ApiClient(dio: dio, tokenStorage: tokenStorage);
  });

  test('per-request Authorization header overrides default Bearer injection',
      () async {
    final response = await apiClient.get(
      '/retail-outlets/',
      headers: {'Authorization': 'Bearer per-request-token'},
    );

    final data = response.data as Map<String, dynamic>;
    expect(data['received'], 'Bearer per-request-token');
  });

  test('without per-request header, default Bearer token is injected',
      () async {
    final response = await apiClient.get('/some-protected-endpoint');

    final data = response.data as Map<String, dynamic>;
    expect(data['received'], 'Bearer default-token');
  });

  test('per-request header override works on POST', () async {
    final response = await apiClient.post(
      '/auth/login',
      data: {'login': 'user', 'password': 'pass'},
      headers: {'Authorization': 'Bearer fresh-token'},
    );

    final data = response.data as Map<String, dynamic>;
    expect(data['received'], 'Bearer fresh-token');
  });
}
