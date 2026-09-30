import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository_impl.dart';
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
        'payment': {
          'method': method,
          'tendered': '45.00',
          'change': '0.00',
        },
        'status': status,
        'created_at': '2026-01-01T00:00:00Z',
        ...?overrides,
      },
    },
  );
}

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
}
