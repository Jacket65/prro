import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/data/repositories/order_history_repository_impl.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiClient extends Mock implements ApiClientI {}

/// A shift row as the backend sends it inside the page envelope.
Map<String, dynamic> _shiftJson({int id = 5}) => {
  'id': id,
  'outlet_id': 7,
  'opened_by': 3,
  'opened_at': '2026-01-02T09:00:00Z',
  'status': 'open',
  'closed_by': null,
  'closed_at': null,
  'cash_end': null,
};

/// A page envelope: `{data: {items, page, has_next, next_page}}`.
Map<String, dynamic> _page(
  List<Map<String, dynamic>> items, {
  int page = 1,
  bool hasNext = false,
  int? nextPage,
}) => {
  'data': {
    'items': items,
    'page': page,
    'has_next': hasNext,
    'next_page': ?nextPage,
  },
};

Response<dynamic> _response(
  String path,
  Map<String, dynamic> body, {
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
      'error': {'code': 'internal_error', 'message': 'boom'},
    },
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockApiClient apiClient;
  late OrderHistoryRepositoryImpl repository;

  setUp(() async {
    apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({'outlet_id': 7});
    final prefs = await SharedPreferences.getInstance();
    repository = OrderHistoryRepositoryImpl(
      apiClient: apiClient,
      outlets: OutletSession(prefs),
    );
  });

  group('getShifts', () {
    test(
      'sends page/sort/order as query parameters and decodes the page',
      () async {
        when(
          () => apiClient.get(
            any<String>(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (inv) async => _response(
            inv.positionalArguments.first as String,
            _page(
              [_shiftJson(), _shiftJson(id: 4)],
              page: 2,
              hasNext: true,
              nextPage: 3,
            ),
          ),
        );

        final page = await repository.getShifts(page: 2);

        verify(
          () => apiClient.get(
            '/retail-outlets/7/shifts',
            queryParameters: {'page': 2, 'sort': 'opened_at', 'order': 'desc'},
          ),
        ).called(1);

        expect(page.items, hasLength(2));
        expect(page.items.first.id, 5);
        expect(page.items.first.outletId, 7);
        expect(page.items.first.isOpen, isTrue);
        expect(page.page, 2);
        expect(page.hasNext, isTrue);
        expect(page.nextPage, 3);
      },
    );

    test(
      'an explicit outlet id scopes the path instead of the session one',
      () async {
        when(
          () => apiClient.get(
            any<String>(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (inv) async =>
              _response(inv.positionalArguments.first as String, _page([])),
        );

        await repository.getShifts(outletId: 12);

        verify(
          () => apiClient.get(
            '/retail-outlets/12/shifts',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      },
    );

    test('accepts a page object at the top level (no envelope)', () async {
      when(
        () => apiClient.get(
          any<String>(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (inv) async => _response(inv.positionalArguments.first as String, {
          'items': [_shiftJson()],
          'page': 1,
          'has_next': false,
        }),
      );

      final page = await repository.getShifts();

      expect(page.items.single.id, 5);
      expect(page.hasNext, isFalse);
    });

    test('a missing outlet in the session fails before any request', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final sessionLess = OrderHistoryRepositoryImpl(
        apiClient: apiClient,
        outlets: OutletSession(prefs),
      );

      await expectLater(
        sessionLess.getShifts(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'Точку продажу не визначено. Увійдіть знову.',
          ),
        ),
      );
      verifyNoMoreInteractions(apiClient);
    });
  });

  group('getShiftOrders', () {
    test('sends shift-scoped page/sort/order and decodes the rows', () async {
      when(
        () => apiClient.get(
          any<String>(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (inv) async => _response(
          inv.positionalArguments.first as String,
          _page(
            [
              {
                'order_id': 11,
                'created_at': '2026-01-02T10:00:00Z',
                'total_price': '45.00',
              },
            ],
            hasNext: true,
            nextPage: 2,
          ),
        ),
      );

      final page = await repository.getShiftOrders(
        5,
        sort: 'created_at',
        order: 'desc',
      );

      verify(
        () => apiClient.get(
          '/shifts/5/orders',
          queryParameters: {'page': 1, 'sort': 'created_at', 'order': 'desc'},
        ),
      ).called(1);

      final row = page.items.single;
      expect(row.orderId, 11);
      expect(row.totalKopecks, 4500);
      expect(page.hasNext, isTrue);
      expect(page.nextPage, 2);
    });

    test('a legacy row still resolves its id from the id key', () async {
      when(
        () => apiClient.get(
          any<String>(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (inv) async => _response(
          inv.positionalArguments.first as String,
          _page([
            {
              'id': 9,
              'created_at': '2026-01-02T10:00:00Z',
              'total_price': '3.5',
            },
          ]),
        ),
      );

      final page = await repository.getShiftOrders(
        5,
        sort: 'created_at',
        order: 'asc',
      );

      expect(page.items.single.orderId, 9);
      expect(page.items.single.totalKopecks, 350);
    });
  });

  group('getOrder', () {
    test('decodes the full receipt from the data envelope', () async {
      when(() => apiClient.get(any<String>())).thenAnswer(
        (inv) async => _response(inv.positionalArguments.first as String, {
          'data': {
            'id': 11,
            'shift_id': 5,
            'status': 'completed',
            'created_at': '2026-01-02T10:00:00Z',
            'total_price': '45.00',
            'items': [
              {
                'name': 'Еспресо',
                'quantity': '2',
                'unit_price': '35.00',
                'line_total': '70.00',
                'variant_id': '1',
                'options': [
                  {
                    'name': 'Соєве молоко',
                    'price_delta': '10.00',
                    'quantity': 2,
                  },
                ],
              },
            ],
            'payment': {
              'method': 'cash',
              'tendered': '50.00',
              'change': '5.00',
              'total': '45.00',
            },
          },
        }),
      );

      final detail = await repository.getOrder(11);

      verify(() => apiClient.get('/orders/11')).called(1);
      expect(detail.orderId, 11);
      expect(detail.shiftId, 5);
      expect(detail.status, 'completed');
      expect(detail.totalKopecks, 4500);

      final item = detail.items.single;
      expect(item.name, 'Еспресо');
      expect(item.quantity, '2');
      expect(item.unitPriceKopecks, 3500);
      expect(item.lineTotalKopecks, 7000);
      final option = item.options.single;
      expect(option.name, 'Соєве молоко');
      expect(option.priceDeltaKopecks, 1000);
      expect(option.quantity, 2);

      expect(detail.payment.method, PaymentMethod.cash);
      expect(detail.payment.tenderedKopecks, 5000);
      expect(detail.payment.changeKopecks, 500);
      expect(detail.payment.totalKopecks, 4500);
    });

    test(
      'a bare body decodes too, and total falls back to payment.total',
      () async {
        when(() => apiClient.get(any<String>())).thenAnswer(
          (inv) async => _response(inv.positionalArguments.first as String, {
            'order_id': 12,
            'shift_id': 5,
            'status': 'completed',
            'created_at': '2026-01-02T10:00:00Z',
            'items': const <dynamic>[],
            'payment': {
              'method': 'card',
              'tendered': '45.00',
              'change': '0.00',
              'total': '45.00',
            },
          }),
        );

        final detail = await repository.getOrder(12);

        expect(detail.orderId, 12);
        expect(detail.totalKopecks, 4500);
        // A historic `"card"` wire value maps to the terminal method.
        expect(detail.payment.method, PaymentMethod.terminal);
      },
    );
  });

  group('error mapping', () {
    void stubError(String path, int status) {
      when(
        () => apiClient.get(
          any<String>(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(_error(path, status));
      when(() => apiClient.get(any<String>())).thenThrow(_error(path, status));
    }

    test(
      'a 404 maps to an ApiException carrying the status and code',
      () async {
        stubError('/retail-outlets/7/shifts', 404);

        await expectLater(
          () => repository.getShifts(),
          throwsA(
            isA<ApiException>()
                .having((e) => e.statusCode, 'statusCode', 404)
                .having((e) => e.code, 'code', 'internal_error'),
          ),
        );
      },
    );

    test('a 401 maps to an ApiException carrying the status', () async {
      stubError('/shifts/5/orders', 401);

      await expectLater(
        () => repository.getShiftOrders(5, sort: 'created_at', order: 'desc'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });

    test('a 500 maps to an ApiException carrying the status', () async {
      stubError('/orders/11', 500);

      await expectLater(
        () => repository.getOrder(11),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });
}
