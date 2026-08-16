import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository_impl.dart';

class MockApiClient extends Mock implements ApiClientI {}

Response<dynamic> _json(dynamic data, {int status = 200, String path = '/'}) =>
    Response<dynamic>(
      requestOptions: RequestOptions(path: path),
      data: data,
      statusCode: status,
    );

void main() {
  late AdminCatalogRepositoryImpl repository;
  late MockApiClient apiClient;

  setUp(() {
    apiClient = MockApiClient();
    repository = AdminCatalogRepositoryImpl(apiClient);
  });

  group('envelope parsing', () {
    test('fetchCategories unwraps {data:[...]}', () async {
      when(
        () => apiClient.get(any()),
      ).thenAnswer(
        (_) async => _json({
          'data': [
            {'id': 1, 'name': 'Кава'},
          ],
        }),
      );

      final categories = await repository.fetchCategories(outletId: 1);

      expect(categories, [const AdminCategory(id: 1, name: 'Кава')]);
      verify(
        () => apiClient.get('/retail-outlets/1/categories'),
      ).called(1);
    });

    test('fetchMeasures parses MeasureUnit list', () async {
      when(
        () => apiClient.get(any()),
      ).thenAnswer(
        (_) async => _json({
          'data': [
            {'id': 3, 'name': 'шт', 'step': '1'},
          ],
        }),
      );

      final units = await repository.fetchMeasures();

      expect(units, hasLength(1));
      expect(units.first.name, 'шт');
    });

    test('AdminVariant price is parsed from kopecks (double string)', () async {
      when(
        () => apiClient.get(any()),
      ).thenAnswer(
        (_) async => _json({
          'data': [
            {
              'id': 2,
              'name': '250 мл',
              'price': '45.50',
              'product_id': 101,
            },
          ],
        }),
      );

      final variants = await repository.fetchVariants(productId: 101);

      expect(variants.first.priceKopecks, 4550);
    });
  });

  group('state-changing calls', () {
    test('createCategory POSTs with idempotency key', () async {
      when(
        () => apiClient.post(
          any(),
          data: any(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer(
        (_) async => _json({
          'data': {'id': 9, 'name': 'Нове'},
        }, status: 201),
      );

      final created = await repository.createCategory(
        outletId: 1,
        name: 'Нове',
        idempotencyKey: 'key-123',
      );

      expect(created, const AdminCategory(id: 9, name: 'Нове'));
      verify(
        () => apiClient.post(
          '/retail-outlets/1/categories',
          data: {'name': 'Нове'},
          idempotencyKey: 'key-123',
        ),
      ).called(1);
    });

    test('createVariant sends price as decimal string + ingredients', () async {
      when(
        () => apiClient.post(
          any(),
          data: any(named: 'data'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer(
        (_) async => _json({
          'data': {'id': 5, 'name': 'Еспресо', 'price': '35.00'},
        }, status: 201),
      );

      await repository.createVariant(
        productId: 101,
        name: 'Еспресо',
        priceKopecks: 3500,
        ingredients: const [
          RecipeIngredient(ingredientId: 1, name: 'Кава', quantity: 1),
        ],
        idempotencyKey: 'v-key',
      );

      final captured =
          verify(
                () => apiClient.post(
                  '/products/101/variants',
                  data: captureAny(named: 'data'),
                  idempotencyKey: 'v-key',
                ),
              ).captured.single
              as Map<String, dynamic>;

      expect(captured['price'], '35.00');
      expect(captured['ingredients'], hasLength(1));
    });

    test('replaceRecipe PUTs with ingredients body', () async {
      when(
        () => apiClient.put(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => _json({'data': []}));

      await repository.replaceRecipe(
        variantId: 5,
        ingredients: const [
          RecipeIngredient(ingredientId: 2, name: 'Молоко', quantity: 0.1),
        ],
      );

      final captured =
          verify(
                () => apiClient.put(
                  '/variants/5/recipe',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;

      expect(captured['ingredients'], hasLength(1));
    });

    test('deleteCategory issues DELETE on /categories/:id', () async {
      when(
        () => apiClient.delete(any()),
      ).thenAnswer((_) async => _json(null, status: 204));

      await repository.deleteCategory(id: 7);

      verify(() => apiClient.delete('/categories/7')).called(1);
    });
  });
}
