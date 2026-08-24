import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/data/api/api_client.dart';

class MockTokenStorage extends Mock implements TokenStorageI {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

Future<void> fireUnauthorized(ApiClient client) async {
  try {
    await client.get('/some-path');
  } on Object {
    // expected: every request resolves with a 401 DioException
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  late ApiClient apiClient;
  late MockHttpClientAdapter adapter;
  late MockTokenStorage tokenStorage;

  setUp(() async {
    tokenStorage = MockTokenStorage();
    when(() => tokenStorage.getAccessToken()).thenAnswer(
      (_) async => 'old-access',
    );
    when(() => tokenStorage.getRefreshToken()).thenAnswer(
      (_) async => 'old-refresh',
    );
    when(() => tokenStorage.hasValidSession()).thenAnswer((_) async => true);
    when(() => tokenStorage.saveAccessToken(any())).thenAnswer(
      (_) async {},
    );
    when(() => tokenStorage.clear()).thenAnswer((_) async {});

    adapter = MockHttpClientAdapter();
    when(
      () => adapter.fetch(any(), any(), any()),
    ).thenAnswer((_) async => ResponseBody.fromString('', 401));

    final dio = Dio()..httpClientAdapter = adapter;

    apiClient = ApiClient(dio: dio, tokenStorage: tokenStorage);
  });

  test(
    'N concurrent 401s collapse to one auth-failure event and one cleanup',
    () async {
      final events = <void>[];
      final sub = apiClient.onUnauthorized.listen(events.add);

      await Future.wait(List.generate(3, (_) => fireUnauthorized(apiClient)));
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(events, hasLength(1));
      verify(() => tokenStorage.clear()).called(1);
    },
  );
}
