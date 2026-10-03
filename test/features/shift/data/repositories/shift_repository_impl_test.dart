import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/shift/data/repositories/shift_repository_impl.dart';
import 'package:prro/features/shift/domain/entities/shift.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockApiClient extends Mock implements ApiClientI {}

Response<dynamic> _response(dynamic data) => Response<dynamic>(
  requestOptions: RequestOptions(path: '/test'),
  data: {'data': data},
);

DioException _httpError(int statusCode) => DioException(
  requestOptions: RequestOptions(path: '/test'),
  response: Response<dynamic>(
    requestOptions: RequestOptions(path: '/test'),
    statusCode: statusCode,
  ),
);

const _openShiftJson = <String, dynamic>{
  'id': 11,
  'outlet_id': 7,
  'opened_by': 3,
  'opened_at': '2024-05-01T09:00:00Z',
  'cash_start': '250.00',
  'status': 'open',
};

void main() {
  late _MockApiClient apiClient;
  late ShiftRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'outlet_id': 7});
    apiClient = _MockApiClient();
    repository = ShiftRepositoryImpl(
      apiClient: apiClient,
      prefs: await SharedPreferences.getInstance(),
    );
  });

  group('currentShift', () {
    test('returns the open shift parsed from the envelope', () async {
      when(
        () => apiClient.get(any<String>()),
      ).thenAnswer((_) async => _response(_openShiftJson));

      final result = await repository.currentShift();

      expect(
        result,
        const ShiftResponse(
          id: 11,
          outletId: 7,
          openedBy: 3,
          openedAt: '2024-05-01T09:00:00Z',
          cashStart: '250.00',
          status: 'open',
        ),
      );
      verify(() => apiClient.get('/retail-outlets/7/shift/current')).called(1);
    });

    test(
      'returns null on 404 because "no open shift" is a normal state',
      () async {
        when(() => apiClient.get(any<String>())).thenThrow(_httpError(404));

        expect(await repository.currentShift(), isNull);
      },
    );

    test('rethrows a 500 as ApiException', () async {
      when(() => apiClient.get(any<String>())).thenThrow(_httpError(500));

      await expectLater(
        repository.currentShift(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('openShift', () {
    test('posts the opening cash and forwards the idempotency key', () async {
      when(
        () => apiClient.post(
          any(),
          data: any<dynamic>(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => _response(_openShiftJson));

      final result = await repository.openShift(
        idempotencyKey: 'open-shift-1',
        cashStart: '250.00',
      );

      expect(result.id, 11);
      verify(
        () => apiClient.post(
          '/retail-outlets/7/shift/open',
          data: {'cash_start': '250.00'},
          idempotencyKey: 'open-shift-1',
        ),
      ).called(1);
    });

    test('wraps a failure in ApiException', () async {
      when(
        () => apiClient.post(
          any(),
          data: any<dynamic>(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(_httpError(409));

      await expectLater(
        repository.openShift(idempotencyKey: 'open-shift-1'),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('closeShift', () {
    test('posts the counted cash and forwards the idempotency key', () async {
      when(
        () => apiClient.post(
          any(),
          data: any<dynamic>(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => _response(null));

      await repository.closeShift(
        cashEnd: '410.00',
        idempotencyKey: 'close-shift-1',
      );

      verify(
        () => apiClient.post(
          '/retail-outlets/7/shift/close',
          data: {'cash_end': '410.00'},
          idempotencyKey: 'close-shift-1',
        ),
      ).called(1);
    });

    test('wraps a failure in ApiException', () async {
      when(
        () => apiClient.post(
          any(),
          data: any<dynamic>(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(_httpError(500));

      await expectLater(
        repository.closeShift(
          cashEnd: '410.00',
          idempotencyKey: 'close-shift-1',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('missing outlet', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      repository = ShiftRepositoryImpl(
        apiClient: apiClient,
        prefs: await SharedPreferences.getInstance(),
      );
    });

    test('fails with a Ukrainian ApiException before any request', () async {
      await expectLater(
        repository.currentShift(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'Точку продажу не визначено. Увійдіть знову.',
          ),
        ),
      );
      verifyNever(() => apiClient.get(any<String>()));
      verifyNever(
        () => apiClient.post(
          any(),
          data: any<dynamic>(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
    });
  });
}
