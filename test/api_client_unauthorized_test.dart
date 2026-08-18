import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences prefs;

  setUp(() async {
    // Preload a live session so a refresh attempt is actually made and fails,
    // exercising the single-flight refresh + idempotent cleanup path.
    SharedPreferences.setMockInitialValues({
      'auth_token': 'old-access',
      'refresh_token': 'old-refresh',
      'isLogged': true,
    });
    prefs = await SharedPreferences.getInstance();

    adapter = MockHttpClientAdapter();
    // Every data request returns 401 (not an auth call, not yet retried) so the
    // interceptor's refresh-and-fail path runs for each concurrent request.
    when(
      () => adapter.fetch(any(), any(), any()),
    ).thenAnswer((_) async => ResponseBody.fromString('', 401));

    final dio = Dio()..httpClientAdapter = adapter;

    apiClient = ApiClient(dio: dio, prefs: prefs);
  });

  test(
    'N concurrent 401s collapse to one auth-failure event and one cleanup',
    () async {
      final events = <void>[];
      final sub = apiClient.onUnauthorized.listen(events.add);

      // Fire >=3 concurrent unauthorized requests against the interceptor.
      await Future.wait(List.generate(3, (_) => fireUnauthorized(apiClient)));
      // Let the interceptor's awaited cleanup settle.
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      // Invariant: single-flight refresh + `hadSession` guard → exactly one
      // onUnauthorized event, and the session is cleared exactly once.
      expect(events, hasLength(1));
      expect(prefs.getString('auth_token'), isNull);
      expect(prefs.getString('refresh_token'), isNull);
      expect(prefs.getBool('isLogged'), isFalse);
    },
  );
}
