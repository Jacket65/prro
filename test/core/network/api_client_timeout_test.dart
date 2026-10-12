import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/config/network_timeouts.dart';
import 'package:prro/core/network/api_client.dart';
import 'package:prro/core/security/token_storage_i.dart';

class MockTokenStorage extends Mock implements TokenStorageI {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  late ApiClient apiClient;
  late MockHttpClientAdapter adapter;
  late MockTokenStorage tokenStorage;
  late List<RequestOptions> seenRequests;

  setUp(() {
    tokenStorage = MockTokenStorage();
    when(
      () => tokenStorage.getAccessToken(),
    ).thenAnswer((_) async => 'default-token');
    when(
      () => tokenStorage.getRefreshToken(),
    ).thenAnswer((_) async => 'some-refresh');
    when(() => tokenStorage.hasValidSession()).thenAnswer((_) async => true);
    when(() => tokenStorage.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});

    seenRequests = [];
    adapter = MockHttpClientAdapter();
    when(() => adapter.fetch(any(), any(), any())).thenAnswer((
      invocation,
    ) async {
      seenRequests.add(invocation.positionalArguments[0] as RequestOptions);
      return ResponseBody.fromString(
        '{"ok":true}',
        200,
        headers: {
          'content-type': ['application/json'],
        },
      );
    });

    final dio = Dio()..httpClientAdapter = adapter;
    apiClient = ApiClient(dio: dio, tokenStorage: tokenStorage);
  });

  RequestOptions onlyRequest() {
    expect(seenRequests, hasLength(1));
    return seenRequests.single;
  }

  group('per-request timeout', () {
    test('is forwarded to dio as the connect and receive bound', () async {
      await apiClient.get('/things', timeout: NetworkTimeouts.auth);

      final options = onlyRequest();
      expect(options.connectTimeout, NetworkTimeouts.auth);
      expect(options.receiveTimeout, NetworkTimeouts.auth);
    });

    test('an unannotated call keeps the client-wide 10 s defaults', () async {
      await apiClient.get('/things');

      final options = onlyRequest();
      expect(options.connectTimeout, NetworkTimeouts.standard);
      expect(options.receiveTimeout, NetworkTimeouts.standard);
    });

    test('is forwarded for every verb, alongside headers and idempotency',
        () async {
      await apiClient.post('/things', timeout: NetworkTimeouts.auth);
      await apiClient.patch('/things', timeout: NetworkTimeouts.auth);
      await apiClient.put('/things', timeout: NetworkTimeouts.auth);
      await apiClient.delete('/things', timeout: NetworkTimeouts.auth);

      expect(seenRequests.map((o) => o.method), [
        'POST',
        'PATCH',
        'PUT',
        'DELETE',
      ]);
      for (final options in seenRequests) {
        expect(options.connectTimeout, NetworkTimeouts.auth);
        expect(options.receiveTimeout, NetworkTimeouts.auth);
      }
    });

    test('an explicit timeout does not drop headers or the idempotency key',
        () async {
      await apiClient.post(
        '/things',
        idempotencyKey: 'key-1',
        headers: {'X-Test': '1'},
        timeout: NetworkTimeouts.auth,
      );

      final options = onlyRequest();
      expect(options.headers['X-Test'], '1');
      expect(options.headers['Idempotency-Key'], 'key-1');
      expect(options.connectTimeout, NetworkTimeouts.auth);
    });
  });
}
