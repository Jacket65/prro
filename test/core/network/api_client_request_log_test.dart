import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/network/api_client.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:talker/talker.dart';

class MockTokenStorage extends Mock implements TokenStorageI {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

/// Collects the records instead of printing them.
class CapturingObserver extends TalkerObserver {
  final List<TalkerData> records = <TalkerData>[];

  @override
  void onLog(TalkerData log) => records.add(log);
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  late MockTokenStorage tokenStorage;
  late MockHttpClientAdapter adapter;
  late CapturingObserver observer;
  late Talker talker;
  late ApiClient apiClient;

  setUp(() {
    tokenStorage = MockTokenStorage();
    when(
      () => tokenStorage.getAccessToken(),
    ).thenAnswer((_) async => 'access-token');
    when(
      () => tokenStorage.getRefreshToken(),
    ).thenAnswer((_) async => 'refresh-token');
    when(() => tokenStorage.hasValidSession()).thenAnswer((_) async => true);
    when(() => tokenStorage.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});

    adapter = MockHttpClientAdapter();
    when(
      () => adapter.fetch(any(), any(), any()),
    ).thenAnswer((_) async => ResponseBody.fromString('{"ok":true}', 200));

    observer = CapturingObserver();
    talker = Talker(observer: observer);

    final dio = Dio()..httpClientAdapter = adapter;
    apiClient = ApiClient(dio: dio, tokenStorage: tokenStorage, talker: talker);
  });

  List<TalkerData> loggedRecords() => observer.records;

  test('logs the request line and the body that is sent', () async {
    await apiClient.post(
      '/retail-outlets/1/orders',
      data: {
        'type': 'cash',
        'products': [
          {'id': 173, 'quantity': '1'},
        ],
      },
    );

    final records = loggedRecords();
    expect(
      records.any(
        (r) =>
            r.key == TalkerKey.httpRequest &&
            r.message?.contains('/retail-outlets/1/orders') == true,
      ),
      isTrue,
    );
    expect(
      records.any(
        (r) =>
            r.message?.contains('[REQUEST BODY]') == true &&
            r.message?.contains('"id": 173') == true &&
            r.message?.contains('"quantity": "1"') == true,
      ),
      isTrue,
    );
  });

  test('redacts credentials in the logged request body', () async {
    await apiClient.post(
      '/auth/login',
      data: {'login': 'user', 'password': 'super-secret'},
    );

    final body = loggedRecords()
        .firstWhere((r) => r.message?.contains('[REQUEST BODY]') == true)
        .message!;
    expect(body, isNot(contains('super-secret')));
    expect(body, contains('"login": "user"'));
  });

  test('does not log a body for a request without one', () async {
    await apiClient.get('/retail-outlets/1/categories');

    expect(
      loggedRecords().any((r) => r.message?.contains('[REQUEST BODY]') == true),
      isFalse,
    );
  });

  test('logs the error body when the server answers with an error', () async {
    when(
      () => adapter.fetch(any(), any(), any()),
    ).thenAnswer(
      (_) async => ResponseBody.fromString(
        '{"error":{"code":"internal_error","message":"empty slice found"}}',
        500,
      ),
    );

    await expectLater(
      apiClient.get('/retail-outlets/1/orders'),
      throwsA(isA<DioException>()),
    );

    final records = loggedRecords();
    expect(records.any((m) => m.key == TalkerKey.httpError), isTrue);
    expect(
      records.any(
        (r) =>
            r.message?.contains('[ERROR BODY]') == true &&
            r.message?.contains('empty slice found') == true,
      ),
      isTrue,
    );
  });
}
