import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/seller/data/repositories/orders_repository_impl.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiClient extends Mock implements ApiClientI {}

/// The cart total the fixtures below are built around: one 45.00 line.
const _totalKopecks = 4500;

/// Over-tender: the customer hands over more than the total. This is the
/// realistic cash case and the one the old fixtures never exercised (they used
/// tendered == total, which hides the distinction between "amount to charge"
/// and "amount handed over"). The wire contract is: `payment.amount` carries
/// the **tendered** amount, the backend computes `change = tendered − total`
/// and books the cash movement for the **total** (verified backend behaviour,
/// `order.go:79-103, 236-247`).
const _overTenderKopecks = 5000;

const _exactTenderKopecks = 4500;

/// Formats kopecks as the decimal string the backend uses on the wire.
String _money(int kopecks) => (kopecks / 100).toStringAsFixed(2);

Response<dynamic> _orderResponse(
  String path, {
  Map<String, dynamic>? overrides,
  String status = 'completed',
  String method = 'cash',
  int tenderedKopecks = _exactTenderKopecks,
}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: path),
    statusCode: 201,
    data: {
      'data': {
        'order_id': 11,
        'items': const <dynamic>[],
        'total_price': _money(_totalKopecks),
        'payment': {
          'method': method,
          'tendered': _money(tenderedKopecks),
          'change': _money(tenderedKopecks - _totalKopecks),
        },
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

  /// Re-stubs the default response with a specific tendered amount, so the
  /// fixture always mirrors what the caller handed over.
  void stubResponseWithTendered(int tenderedKopecks) {
    when(
      () => apiClient.post(
        any<String>(),
        data: any<dynamic>(named: 'data'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer(
      (inv) async => _orderResponse(
        inv.positionalArguments.first as String,
        tenderedKopecks: tenderedKopecks,
      ),
    );
  }

  setUp(() async {
    apiClient = MockApiClient();
    SharedPreferences.setMockInitialValues({
      'outlet_id': 7,
      'username': 'cashier1',
    });
    final prefs = await SharedPreferences.getInstance();
    repo = OrdersRepositoryImpl(
      apiClient: apiClient,
      prefs: prefs,
      outlets: OutletSession(prefs),
    );

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
        tenderedKopecks: _overTenderKopecks,
        idempotencyKey: 'k1',
      );

      final body = capturedBody();
      expect(body['type'], 'cash');
      // `payment.amount` is the TENDERED amount, not the cart total: the
      // backend derives the charge from the order lines and returns the
      // change, so the client must never pre-trim the tendered figure.
      expect(body['payment'], {
        'method': 'cash',
        'amount': _money(_overTenderKopecks),
      });
      expect(body['products'], isA<List<dynamic>>());
    });

    test('carries top-level type=card for terminal orders (backend '
        'validates oneof=cash card)', () async {
      await repo.placeOrder(
        method: PaymentMethod.terminal,
        tenderedKopecks: _overTenderKopecks,
        idempotencyKey: 'k2',
      );

      final body = capturedBody();
      expect(body['type'], 'card');
      expect(body['payment'], {
        'method': 'card',
        'amount': _money(_overTenderKopecks),
      });
    });

    test(
      'posts to the outlet-scoped orders route with the idempotency key',
      () async {
        await repo.placeOrder(
          method: PaymentMethod.cash,
          tenderedKopecks: _overTenderKopecks,
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

    test('an over-tender returns the parsed tendered amount and the server '
        'change', () async {
      stubResponseWithTendered(_overTenderKopecks);

      final receipt = await repo.placeOrder(
        method: PaymentMethod.cash,
        tenderedKopecks: _overTenderKopecks,
        idempotencyKey: 'k-over',
      );

      expect(receipt.totalKopecks, _totalKopecks);
      expect(receipt.tenderedKopecks, _overTenderKopecks);
      expect(receipt.changeKopecks, 500);
    });

    test('an exact tender returns zero change', () async {
      final receipt = await repo.placeOrder(
        method: PaymentMethod.cash,
        tenderedKopecks: _exactTenderKopecks,
        idempotencyKey: 'k-exact',
      );

      expect(receipt.totalKopecks, _totalKopecks);
      expect(receipt.tenderedKopecks, _exactTenderKopecks);
      expect(receipt.changeKopecks, 0);
    });

    test(
      'a 404 becomes ShiftClosedException, not a bare ApiException',
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
            tenderedKopecks: _overTenderKopecks,
            idempotencyKey: 'k5',
          ),
          throwsA(isA<ShiftClosedException>()),
        );
      },
    );

    test(
      'a 404 on the terminal path also becomes ShiftClosedException',
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
            tenderedKopecks: _overTenderKopecks,
            idempotencyKey: 'k6',
          ),
          throwsA(isA<ShiftClosedException>()),
        );
      },
    );

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
          tenderedKopecks: _overTenderKopecks,
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
      repo = OrdersRepositoryImpl(
      apiClient: apiClient,
      prefs: prefs,
      outlets: OutletSession(prefs),
    );

      expect(
        () => repo.placeOrder(
          method: PaymentMethod.cash,
          tenderedKopecks: _overTenderKopecks,
          idempotencyKey: 'k4',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('cart forwarding (shares the domain Cart)', () {
    Product line({
      required String id,
      required String price,
      required String quantity,
      List<SelectedOption> options = const [],
    }) => Product(
      id: id,
      name: 'Позиція $id',
      price: Decimal.parse(price),
      quantity: Decimal.parse(quantity),
      imageUrl: '',
      selectedOptions: options,
    );

    test(
      'the repository exposes the shared cart, priced in exact Decimal',
      () async {
        // 0.300 × 33.33 = 9.999; 0.700 × 33.33 = 23.331;
        // 2 × (45.00 + 25.00×2 portions) = 190.00 → the cart is 223.33,
        //which the
        // double path prints as 223.32999999999998. (The full cart API coverage
        // lives in `cart_test.dart` — this pins the forwarding.)
        repo
          ..addProduct(line(id: 'a', price: '33.33', quantity: '0.300'))
          ..addProduct(line(id: 'b', price: '33.33', quantity: '0.700'))
          ..addProduct(
            line(
              id: 'c',
              price: '45.00',
              quantity: '2',
              options: [
                SelectedOption(
                  optionId: 2,
                  name: 'Соєве',
                  priceDelta: Decimal.parse('25.00'),
                  quantity: 2,
                ),
              ],
            ),
          );

        expect(repo.products, hasLength(3));
        expect(repo.totalPrice, Decimal.parse('223.33'));
        expect(repo.totalPrice.toString(), '223.33');

        // The only conversion to kopecks happens at the payment boundary,
        //and it
        // lands exactly on the figure the same lines bill on the wire.
        final totalKopecks = kopecksFromDecimal(repo.totalPrice);
        expect(totalKopecks, 22333);

        await repo.placeOrder(
          method: PaymentMethod.cash,
          tenderedKopecks: totalKopecks,
          idempotencyKey: 'k-total',
        );
        expect(capturedBody()['payment'], {
          'method': 'cash',
          'amount': '223.33',
        });
      },
    );

    test('updateOptions reaches the shared cart', () {
      final lineP = line(id: 'p1', price: '45', quantity: '1');
      repo
        ..addProduct(lineP)
        ..updateOptions(lineP.lineId, [
          SelectedOption(
            optionId: 2,
            name: 'Молоко',
            priceDelta: Decimal.parse('5'),
          ),
        ]);

      expect(repo.products.single.lineId, 'p1#2x1;');
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
        expect(receipt.totalKopecks, _totalKopecks);
        // The confirm receipt keeps the tendered/change pair the card order was
        // created with, so the printed receipt matches the sale.
        expect(receipt.tenderedKopecks, _exactTenderKopecks);
        expect(receipt.changeKopecks, 0);
      },
    );
  });
}
