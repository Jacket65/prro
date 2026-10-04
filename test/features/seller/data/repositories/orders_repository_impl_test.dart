import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/seller/data/repositories/orders_repository_impl.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiClient extends Mock implements ApiClientI {}

Response<dynamic> _orderResponse(
  String path, {
  Map<String, dynamic>? overrides,
  String status = 'completed',
  String method = 'cash',
}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: path),
    statusCode: 201,
    data: {
      'data': {
        'order_id': 11,
        'items': const <dynamic>[],
        'total_price': '45.00',
        'payment': {'method': method, 'tendered': '45.00', 'change': '0.00'},
        'status': status,
        'created_at': '2026-01-01T00:00:00Z',
        ...?overrides,
      },
    },
  );
}

/// A backend 404 on order creation: the seller's shift was closed from another
/// device while this screen was open.
DioException _notFound() => DioException(
      requestOptions: RequestOptions(path: '/retail-outlets/7/orders'),
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/retail-outlets/7/orders'),
        statusCode: 404,
        data: {
          'error': {'code': 'not_found', 'message': 'shift not found'},
        },
      ),
    );

/// A backend 500, to prove the 404 mapping is narrow.
DioException _serverError() => DioException(
      requestOptions: RequestOptions(path: '/retail-outlets/7/orders'),
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/retail-outlets/7/orders'),
        statusCode: 500,
        data: {
          'error': {'code': 'internal_error', 'message': 'boom'},
        },
      ),
    );

void main() {
  late MockApiClient apiClient;
  late OrdersRepositoryImpl repo;

  setUp(() async {
    apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({
      'outlet_id': 7,
      'username': 'cashier1',
    });
    final prefs = await SharedPreferences.getInstance();
    repo = OrdersRepositoryImpl(apiClient: apiClient, prefs: prefs);

    when(
      () => apiClient.post(
        any<String>(),
        data: any<dynamic>(named: 'data'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer(
      (inv) async => _orderResponse(inv.positionalArguments.first as String),
    );
  });

  Map<String, dynamic> capturedBody() =>
      verify(
            () => apiClient.post(
              any<String>(),
              data: captureAny<dynamic>(named: 'data'),
              idempotencyKey: any(named: 'idempotencyKey'),
            ),
          ).captured.single
          as Map<String, dynamic>;

  group('placeOrder body', () {
    test('carries top-level type=cash for cash orders', () async {
      await repo.placeOrder(
        method: PaymentMethod.cash,
        tenderedKopecks: 4500,
        idempotencyKey: 'k1',
      );

      final body = capturedBody();
      expect(body['type'], 'cash');
      expect(body['payment'], {'method': 'cash', 'amount': '45.00'});
      expect(body['products'], isA<List<dynamic>>());
    });

    test('carries top-level type=card for terminal orders (backend '
        'validates oneof=cash card)', () async {
      await repo.placeOrder(
        method: PaymentMethod.terminal,
        tenderedKopecks: 4500,
        idempotencyKey: 'k2',
      );

      final body = capturedBody();
      expect(body['type'], 'card');
      expect(body['payment'], {'method': 'card', 'amount': '45.00'});
    });

    test(
      'posts to the outlet-scoped orders route with the idempotency key',
      () async {
        await repo.placeOrder(
          method: PaymentMethod.cash,
          tenderedKopecks: 4500,
          idempotencyKey: 'k3',
        );

        verify(
          () => apiClient.post(
            '/retail-outlets/7/orders',
            data: any<dynamic>(named: 'data'),
            idempotencyKey: 'k3',
          ),
        ).called(1);
      },
    );

    test('a 404 becomes ShiftClosedException, not a bare ApiException',
        () async {
      when(
        () => apiClient.post(
          any<String>(),
          data: any<dynamic>(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(_notFound());

      await expectLater(
        () => repo.placeOrder(
          method: PaymentMethod.cash,
          tenderedKopecks: 4500,
          idempotencyKey: 'k5',
        ),
        throwsA(isA<ShiftClosedException>()),
      );
    });

    test('a 404 on the terminal path also becomes ShiftClosedException',
        () async {
      when(
        () => apiClient.post(
          any<String>(),
          data: any<dynamic>(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(_notFound());

      await expectLater(
        () => repo.placeOrder(
          method: PaymentMethod.terminal,
          tenderedKopecks: 4500,
          idempotencyKey: 'k6',
        ),
        throwsA(isA<ShiftClosedException>()),
      );
    });

    test('a non-404 failure still maps to ApiException', () async {
      when(
        () => apiClient.post(
          any<String>(),
          data: any<dynamic>(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(_serverError());

      await expectLater(
        () => repo.placeOrder(
          method: PaymentMethod.cash,
          tenderedKopecks: 4500,
          idempotencyKey: 'k7',
        ),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    test('throws when no outlet is stored', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repo = OrdersRepositoryImpl(apiClient: apiClient, prefs: prefs);

      expect(
        () => repo.placeOrder(
          method: PaymentMethod.cash,
          tenderedKopecks: 4500,
          idempotencyKey: 'k4',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('confirmOrder', () {
    test(
      'POSTs /orders/{id}/confirm and parses the returned receipt',
      () async {
        final receipt = await repo.confirmOrder(11);

        verify(
          () => apiClient.post(
            '/orders/11/confirm',
            data: any<dynamic>(named: 'data'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).called(1);
        expect(receipt.orderId, '11');
        expect(receipt.status, 'completed');
        expect(receipt.totalKopecks, 4500);
      },
    );
  });

  group('updateOptions', () {
    Product product({Bean? bean, List<SelectedOption> options = const []}) =>
        Product(
          id: 'p1',
          quantity: Decimal.one,
          name: 'Кава',
          price: 45,
          imageUrl: '',
          selectedBean: bean,
          selectedOptions: options,
        );

    List<Product> products() => repo.products;

    test('replaces the options of a line', () {
      final line = product();
      repo.addProduct(line);
      const options = [
        SelectedOption(optionId: 2, name: 'Молоко'),
      ];

      repo.updateOptions(line.lineId, options);

      expect(products().single.selectedOptions, options);
      expect(products().single.lineId, 'p1#2x1;');
    });

    test('omitting bean drops the bean of the line', () {
      final line = product(bean: const Bean(id: 3, name: 'Колумбія'));
      repo.addProduct(line);
      expect(products().single.selectedBean, isNotNull);

      repo.updateOptions(line.lineId, const []);

      expect(products().single.selectedBean, isNull);
      expect(products().single.lineId, 'p1');
    });

    test('passing a bean sets it on the line', () {
      final line = product();
      repo
        ..addProduct(line)
        ..updateOptions(
          line.lineId,
          const [],
          bean: const Bean(id: 4, name: 'x'),
        );

      expect(products().single.selectedBean?.id, 4);
    });

    test('a quantity replaces the line quantity, null keeps it', () {
      final line = product();
      repo
        ..addProduct(line)
        ..updateOptions(line.lineId, const [], quantity: Decimal.fromInt(3));
      expect(products().single.quantity, Decimal.fromInt(3));

      repo.updateOptions(products().single.lineId, const []);
      expect(products().single.quantity, Decimal.fromInt(3));
    });

    test('changing the options merges into an identical existing line', () {
      const options = [SelectedOption(optionId: 2, name: 'Молоко')];
      final plain = product();
      repo
        ..addProduct(plain)
        ..addProduct(product(options: options))
        ..updateOptions(plain.lineId, options);

      expect(products().length, 1);
      expect(products().single.selectedOptions, options);
    });

    test('an unknown lineId is ignored', () {
      repo
        ..addProduct(product())
        ..updateOptions('nope', const []);

      expect(products().length, 1);
    });
  });
}
