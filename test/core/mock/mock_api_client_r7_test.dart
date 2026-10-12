import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/mock/mock_api_client.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/features/admin/data/models/catalog.dart';

void main() {
  late MockBackend backend;
  late MockApiClient client;

  setUp(() {
    backend = MockBackend.instance;
    client = MockApiClient(mockBackend: backend);
  });

  /// A unique key per call: the backend caches receipts by key, and a shared
  /// one would make the second order in the file a replay of the first.
  Future<Response<dynamic>> post(String path, Map<String, dynamic> body) =>
      client.post(
        path,
        data: body,
        idempotencyKey: 'key-${DateTime.now().microsecondsSinceEpoch}',
      );

  /// Runs [run] and returns whatever it threw, or `null` when it did not.
  Future<Object?> errorOf(Future<Response<dynamic>> Function() run) async {
    try {
      await run();
      return null;
    } on Object catch (e) {
      return e;
    }
  }

  group('M2: the real order payload', () {
    test(
      'POST /orders reads products[] with a decimal-string quantity',
      () async {
        // The shape OrdersRepositoryImpl actually sends: `id`, a decimal-string
        // quantity ("2" pieces, "0.250" weight goods), and options.
        final response = await post('/retail-outlets/1/orders', {
          'type': 'cash',
          'products': [
            {
              'id': 1,
              'quantity': '2',
              'options': [
                {'option_id': 1, 'quantity': 1},
              ],
            },
          ],
          // 2 × (₴35.00 + ₴0.00 milk).
          'payment': {'method': 'cash', 'amount': '70.00'},
        });

        expect(response.statusCode, 201);
        final data = response.data as Map<String, dynamic>;
        expect(data['order_id'], isNotNull);
        final items = data['items'] as List<dynamic>;
        expect(items, hasLength(1));
        expect((items.first as Map<String, dynamic>)['quantity'], '2');
        // The line really reached the backend: quantity, option surcharge and
        // unit price all land in the total.
        expect(data['total_price'], '70.00');
      },
    );

    test('a weight-goods quantity is not truncated to zero', () async {
      // The int-quantity DTO used to turn 0.250 into 0, which the backend then
      // rejected as a non-positive quantity.
      // Terminal payments must tender the exact total: 0.250 × ₴35.00.
      final response = await post('/retail-outlets/1/orders', {
        'type': 'card',
        'products': [
          {'id': 1, 'quantity': '0.250'},
        ],
        'payment': {'method': 'card', 'amount': '8.75'},
      });

      expect(response.statusCode, 201);
      final data = response.data as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;
      // `Decimal` normalises the trailing zero; the point is that it is not 0.
      expect((items.first as Map<String, dynamic>)['quantity'], '0.25');
      expect(data['total_price'], '8.75');
    });

    test(
      'an empty cart is refused by the backend, not silently accepted',
      () async {
        final error = await errorOf(
          () => post('/retail-outlets/1/orders', {
            'type': 'cash',
            'products': <Map<String, dynamic>>[],
            'payment': {'method': 'cash', 'amount': '0.00'},
          }),
        );

        expect(error.toString(), contains('Кошик порожній.'));
      },
    );

    test('payment.amount is mapped to the tendered amount', () async {
      final response = await post('/retail-outlets/1/orders', {
        'type': 'cash',
        'products': [
          {'id': 1, 'quantity': '2'},
        ],
        // The exact tender, so there is no change.
        'payment': {'method': 'cash', 'amount': '70.00'},
      });

      final payment =
          (response.data as Map<String, dynamic>)['payment']
              as Map<String, dynamic>;
      expect(payment['method'], 'cash');
      expect(payment['tendered'], '70.00');
      expect(payment['change'], '0.00');
    });
  });

  group('M1: unimplemented routes fail loudly', () {
    test('an unhandled GET answers 404, not a silent empty 200', () async {
      final error = await errorOf(() => client.get('/no/such/endpoint'));

      expect(
        error,
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      );
    });

    test('an unhandled POST answers 404', () async {
      final error = await errorOf(
        () => post('/no/such/endpoint', <String, dynamic>{}),
      );

      expect(
        error,
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      );
    });

    test('an unhandled PATCH answers 404', () async {
      final error = await errorOf(
        () => client.patch('/no/such/endpoint', data: {'name': 'x'}),
      );

      expect(
        error,
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      );
    });

    test('an unhandled PUT answers 404', () async {
      final error = await errorOf(
        () => client.put('/no/such/endpoint', data: {'name': 'x'}),
      );

      expect(
        error,
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      );
    });

    test('an unmatched DELETE answers 404', () async {
      final error = await errorOf(() => client.delete('/no/such/endpoint'));

      expect(
        error,
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      );
    });

    test('every modelled route still succeeds', () async {
      // The assertion is only safe if the routes the client really uses keep
      // passing through it — otherwise a 404 just became a different wall.
      final login = await post('/auth/login', {
        'login': 'admin',
        'password': 'admin123',
      });
      expect(login.statusCode, 200);

      final me = await client.get('/auth/me');
      expect(me.statusCode, 200);

      final outlets = await client.get('/retail-outlets/');
      expect(outlets.statusCode, 200);
    });
  });

  group('login credentials', () {
    test('a valid password logs in', () async {
      final response = await post('/auth/login', {
        'login': 'manager',
        'password': 'manager123',
      });

      expect(response.statusCode, 200);
      final user =
          (response.data as Map<String, dynamic>)['data']
              as Map<String, dynamic>;
      expect(user['login'], 'manager');
      expect(user['role'], 'manager');
    });

    test(
      'a wrong password is rejected, not accepted as any non-empty string',
      () async {
        final response = await post('/auth/login', {
          'login': 'admin',
          'password': 'definitely-not-it',
        });

        expect(response.statusCode, 401);
      },
    );

    test('an empty password is rejected with a request error', () async {
      final response = await post('/auth/login', {
        'login': 'admin',
        'password': '',
      });

      expect(response.statusCode, 400);
    });
  });

  group('M2: the recipe route is a server no-op', () {
    // The real `PUT /variants/{id}/recipe` answers 200 and stores nothing, so
    // the mock must not persist either: otherwise the admin screen looks like
    // it saved while the server quietly reverts, and only a run against the
    // real backend would expose it.
    Future<int> createVariantWithRecipe() async {
      final product = await backend.createAdminProduct(
        categoryId: 1,
        name: 'Капучіно',
      );
      final variant = await backend.createAdminVariant(
        productId: product.id,
        name: '300 мл',
        priceKopecks: 5500,
        ingredients: const [
          RecipeIngredient(ingredientId: 1, name: 'Кава', quantity: 18),
        ],
      );
      return variant.id;
    }

    test('PUT succeeds and leaves the stored recipe alone', () async {
      final variantId = await createVariantWithRecipe();

      final response = await client.put(
        '/variants/$variantId/recipe',
        data: {
          'ingredients': [
            {'ingredient_id': 2, 'name': 'Молоко', 'quantity': '120'},
          ],
        },
      );

      expect(response.statusCode, 200);
      final stored = await backend.getAdminRecipe(variantId);
      expect(stored, hasLength(1));
      expect(stored.single.name, 'Кава');
    });

    test('the mock backend itself does not persist the recipe', () async {
      final variantId = await createVariantWithRecipe();
      final before = await backend.getAdminRecipe(variantId);

      await backend.replaceAdminRecipe(
        variantId: variantId,
        ingredients: const [
          RecipeIngredient(ingredientId: 2, name: 'Молоко', quantity: 120),
        ],
      );

      expect(await backend.getAdminRecipe(variantId), before);
    });

    test(
      'a missing variant still resolves, exactly as the route would',
      () async {
        final error = await errorOf(
          () => client.put(
            '/variants/999999/recipe',
            data: const {'ingredients': <Map<String, dynamic>>[]},
          ),
        );

        expect(error.toString(), contains('Варіант не знайдено.'));
      },
    );
  });
}
