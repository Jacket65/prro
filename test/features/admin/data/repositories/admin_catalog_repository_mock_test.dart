import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/features/admin/data/mock/admin_catalog_repository_mock.dart';
import 'package:prro/features/admin/data/models/catalog.dart';

/// `AdminCatalogRepositoryMock` is the mock-environment binding of
/// `AdminCatalogRepositoryI` (both the repository mock and the `MockApiClient`
/// transport go through `MockBackend`), so it is pinned here: the working
/// routes still walk, and the routes the backend cannot serve fail with the
/// exact sentences the client renders in production — which is what makes the
/// mock demo faithful instead of comfortable.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBackend backend;
  late AdminCatalogRepositoryMock repository;

  setUp(() {
    backend = MockBackend.instance;
    repository = AdminCatalogRepositoryMock(backend);
  });

  group('the admin catalog walk still works in mock mode', () {
    test('categories: list → create → rename → delete', () async {
      final categories = await repository.fetchCategories(outletId: 1);
      expect(categories, isNotEmpty);

      final created = await repository.createCategory(
        outletId: 1,
        name: 'Сезонне',
        idempotencyKey: 'walk-cat',
      );
      expect(created.name, 'Сезонне');

      final renamed = await repository.updateCategory(
        id: created.id,
        name: 'Сезонне меню',
      );
      expect(renamed.name, 'Сезонне меню');

      await repository.deleteCategory(id: created.id);
    });

    test('product: create → variants → recipe read, plus measures', () async {
      final category = await repository.createCategory(
        outletId: 1,
        name: 'Для перевірки',
        idempotencyKey: 'walk-cat-2',
      );

      final product = await repository.createProduct(
        categoryId: category.id,
        name: 'Какао',
        idempotencyKey: 'walk-product',
      );

      final variant = await repository.createVariant(
        productId: product.id,
        name: '250 мл',
        priceKopecks: 6000,
        ingredients: const [
          RecipeIngredient(ingredientId: 1, name: 'Какао', quantity: 15),
        ],
        idempotencyKey: 'walk-variant',
      );

      final variants = await repository.fetchVariants(productId: product.id);
      expect(variants.map((v) => v.id), contains(variant.id));

      final recipe = await repository.fetchRecipe(variantId: variant.id);
      expect(recipe, hasLength(1));

      expect(await repository.fetchMeasures(), isNotEmpty);
      expect(await repository.fetchIngredients(outletId: 1), isNotEmpty);
    });
  });

  group('admin writes fail honestly where the server fails', () {
    test('updateProduct renders the server 500', () async {
      final category = await repository.createCategory(
        outletId: 1,
        name: 'Зламана категорія',
        idempotencyKey: 'broken-cat',
      );
      final product = await repository.createProduct(
        categoryId: category.id,
        name: 'Зламаний продукт',
        idempotencyKey: 'broken-product',
      );

      // What the client shows when `HandleProductUpdate` answers 500: the
      // route is registered but the save violates the FK (23503).
      await expectLater(
        repository.updateProduct(id: product.id, name: 'Перейменовано'),
        throwsA(
          isA<MockBackendException>().having(
            (e) => e.message,
            'message',
            'Помилка сервера.',
          ),
        ),
      );

      // The product is untouched, like the server leaves it.
      await expectLater(
        repository.fetchVariants(productId: product.id),
        completion(anything),
      );
    });

    test('updateVariant and deleteVariant render the bare 404', () async {
      final category = await repository.createCategory(
        outletId: 1,
        name: 'Без редактора варіантів',
        idempotencyKey: 'novariant-cat',
      );
      final product = await repository.createProduct(
        categoryId: category.id,
        name: 'Продукт без редактора',
        idempotencyKey: 'novariant-product',
      );
      final variant = await repository.createVariant(
        productId: product.id,
        name: '250 мл',
        priceKopecks: 6000,
        ingredients: const [],
        idempotencyKey: 'novariant-variant',
      );

      // `PATCH`/`DELETE /variants/{id}` are commented out of the router, so
      // Gin answers a bare 404 and `ApiException._friendly` turns it into
      // this sentence.
      await expectLater(
        repository.updateVariant(
          id: variant.id,
          name: '400 мл',
          priceKopecks: 7000,
        ),
        throwsA(
          isA<MockBackendException>().having(
            (e) => e.message,
            'message',
            'Помилка сервера (404).',
          ),
        ),
      );

      await expectLater(
        repository.deleteVariant(id: variant.id),
        throwsA(
          isA<MockBackendException>().having(
            (e) => e.message,
            'message',
            'Помилка сервера (404).',
          ),
        ),
      );

      // And the variant is still there.
      final variants = await repository.fetchVariants(productId: product.id);
      expect(variants.map((v) => v.id), contains(variant.id));
    });
  });
}
