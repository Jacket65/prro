import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/mock/mock_api_client.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:talker/talker.dart';

void main() {
  late MockBackend backend;
  late MockApiClient client;

  setUp(() {
    backend = MockBackend.instance;
    client = MockApiClient(
      mockBackend: backend,
      talker: Talker(settings: TalkerSettings(useConsoleLogs: false)),
    );
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
  Future<Object?> errorOf(Future<Object?> Function() run) async {
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
      // /auth/me is not one of them: no client interface calls it, so it is
      // pinned as unrouted in `mock_api_client_test.dart` instead.
      final login = await post('/auth/login', {
        'login': 'admin',
        'password': 'admin123',
      });
      expect(login.statusCode, 200);

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
    //
    // The transport branch that used to serve the route is gone (it was
    // unreachable in the mock environment and answered undecodably), so the
    // no-op itself is pinned against `MockBackend` — the layer the
    // repository-level mock actually reaches — and the transport below is
    // pinned as unrouted.
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

    test('the mock backend does not persist the recipe', () async {
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

    test('a missing variant still resolves, as the route would', () async {
      final error = await errorOf(
        () => backend.replaceAdminRecipe(
          variantId: 999999,
          ingredients: const [],
        ),
      );

      expect(error.toString(), contains('Варіант не знайдено.'));
    });

    test('the transport no longer serves the route', () async {
      final variantId = await createVariantWithRecipe();

      final error = await errorOf(
        () => client.put(
          '/variants/$variantId/recipe',
          data: {
            'ingredients': [
              {'ingredient_id': 2, 'name': 'Молоко', 'quantity': '120'},
            ],
          },
        ),
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
  });

  group('P2-1: the mock fails where its server fails', () {
    Future<(int, int)> createProductWithVariant() async {
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
      return (product.id, variant.id);
    }

    test(
      "PATCH /products/{id} answers the server's 500, not a success",
      () async {
        // routes.go:86 registers the route, but the handler saves a partial
        // `Product` (id + name), GORM zeroes `category_id` and the insert
        // violates the FK (23503) → 500. Success here was the lie P2-1 removes.
        final (productId, _) = await createProductWithVariant();

        final error = await errorOf(
          () => client.patch(
            '/products/$productId',
            data: {'name': 'Перейменовано'},
          ),
        );

        expect(
          error,
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            500,
          ),
        );
        final dioError = error! as DioException;
        expect(dioError.response, isNotNull);
        final data = dioError.response!.data as Map<String, dynamic>;
        expect(data['error'], isA<Map<String, dynamic>>());
        expect((data['error'] as Map)['code'], 'internal_error');
        // The sentence a production user sees for that envelope.
        expect(ApiException.fromDio(dioError).message, 'Помилка сервера.');
        // And the product survives untouched, exactly as the server leaves it.
        await expectLater(
          backend.getAdminVariants(productId),
          completion(isNotEmpty),
        );
      },
    );

    test('PATCH /variants/{id} answers 404 (route commented out)', () async {
      // routes.go:106 is commented out, so Gin answers a bare 404 for any id.
      final (_, variantId) = await createProductWithVariant();

      final error = await errorOf(
        () => client.patch(
          '/variants/$variantId',
          data: {'name': '400 мл', 'price': '60.00'},
        ),
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

    test('DELETE /variants/{id} answers 404 (route commented out)', () async {
      // routes.go:107 is commented out, so Gin answers a bare 404 for any id.
      final (productId, variantId) = await createProductWithVariant();

      final error = await errorOf(() => client.delete('/variants/$variantId'));

      expect(
        error,
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      );
      final variants = await backend.getAdminVariants(productId);
      expect(variants.any((v) => v.id == variantId), isTrue);
    });

    test('PATCH /categories/{id} still succeeds and decodes', () async {
      // Registered and working on the server (routes.go:75), so the mock keeps
      // answering — with the wire shape, so `AdminCategory.fromJson` works.
      final response = await client.patch(
        '/categories/1',
        data: {'name': 'Гарячі напої'},
      );

      expect(response.statusCode, 200);
      final category = AdminCategory.fromJson(
        ((response.data as Map<String, dynamic>)['data'] as Map)
            .cast<String, dynamic>(),
      );
      expect(category.id, 1);
      expect(category.name, 'Гарячі напої');
    });

    test(
      'DELETE /categories/{id} and /products/{id} still answer 204',
      () async {
        // Registered and working on the server (routes.go:76, :87).
        final created = await backend.createAdminCategory(
          outletId: 1,
          name: 'Тимчасова',
        );
        final categories = await client.delete('/categories/${created.id}');
        expect(categories.statusCode, 204);

        final (productId, _) = await createProductWithVariant();
        final products = await client.delete('/products/$productId');
        expect(products.statusCode, 204);
      },
    );

    test('the unreachable admin writes/reads fall through to 404', () async {
      // Unreachable in the mock environment: the repository-level mocks
      // (`AdminCatalogRepositoryMock`, `AdminUserRepositoryMock`) intercept
      // before the transport, and they answered undecodably.
      for (final call in <Future<Response<dynamic>> Function()>[
        () => client.post(
          '/retail-outlets/1/categories',
          data: {'name': 'Нова категорія'},
        ),
        () => client.get('/retail-outlets/1/users'),
        () => client.get('/retail-outlets/1/categories'),
        () => client.get('/retail-outlets/1/ingredients'),
        () => client.get('/measure-units'),
        () => client.get('/categories'),
        () => client.get('/products'),
      ]) {
        final error = await errorOf(call);
        expect(
          error,
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            404,
          ),
        );
      }
    });

    test('MockBackend mirrors the 500 and 404 for admin writes', () async {
      // The layer `AdminCatalogRepositoryMock` actually reaches, so mock mode
      // fails with exactly the sentences the client renders in production.
      final (productId, variantId) = await createProductWithVariant();

      final productError = await errorOf(
        () => backend.updateAdminProduct(id: productId, name: 'Капучіно'),
      );
      expect(
        productError,
        isA<MockBackendException>().having(
          (e) => e.message,
          'message',
          'Помилка сервера.',
        ),
      );

      final variantError = await errorOf(
        () => backend.updateAdminVariant(
          id: variantId,
          name: '400 мл',
          priceKopecks: 6000,
        ),
      );
      expect(
        variantError,
        isA<MockBackendException>().having(
          (e) => e.message,
          'message',
          'Помилка сервера (404).',
        ),
      );

      final deleteError = await errorOf(
        () => backend.deleteAdminVariant(id: variantId),
      );
      expect(
        deleteError,
        isA<MockBackendException>().having(
          (e) => e.message,
          'message',
          'Помилка сервера (404).',
        ),
      );

      // Nothing was written by either mirror.
      final variants = await backend.getAdminVariants(productId);
      expect(variants.any((v) => v.id == variantId), isTrue);
    });
  });
}
