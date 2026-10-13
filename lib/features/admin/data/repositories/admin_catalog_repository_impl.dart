import 'package:injectable/injectable.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/utils/envelope.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/domain/repositories/admin_catalog_repository_i.dart';

@Environment('prod')
@Singleton(as: AdminCatalogRepositoryI)
class AdminCatalogRepositoryImpl implements AdminCatalogRepositoryI {
  AdminCatalogRepositoryImpl(this._apiClient);
  final ApiClientI _apiClient;

  // ── Categories ──
  @override
  Future<List<AdminCategory>> fetchCategories({required int outletId}) =>
      dioGuard(() async {
        final response = await _apiClient.get(
          '/retail-outlets/$outletId/categories',
        );
        return unwrapList(response.data, AdminCategory.fromJson);
      });

  @override
  Future<AdminCategory> createCategory({
    required int outletId,
    required String name,
    required String idempotencyKey,
  }) => dioGuard(() async {
    final response = await _apiClient.post(
      '/retail-outlets/$outletId/categories',
      data: {'name': name},
      idempotencyKey: idempotencyKey,
    );
    return await unwrapObject(response.data, AdminCategory.fromJson) ??
        AdminCategory(id: 0, name: name);
  });

  @override
  Future<AdminCategory> updateCategory({
    required int id,
    required String name,
  }) => dioGuard(() async {
    final response = await _apiClient.patch(
      '/categories/$id',
      data: {'name': name},
    );
    return await unwrapObject(response.data, AdminCategory.fromJson) ??
        AdminCategory(id: id, name: name);
  });

  @override
  Future<void> deleteCategory({required int id}) => dioGuard(() async {
    await _apiClient.delete('/categories/$id');
  });

  // ── Products ──
  @override
  Future<List<AdminProduct>> fetchProducts({required int categoryId}) =>
      dioGuard(() async {
        final response = await _apiClient.get(
          '/categories/$categoryId/products',
        );
        return unwrapList(response.data, AdminProduct.fromJson);
      });

  @override
  Future<AdminProduct> createProduct({
    required int categoryId,
    required String name,
    required String idempotencyKey,
  }) => dioGuard(() async {
    final response = await _apiClient.post(
      '/categories/$categoryId/products',
      data: {'name': name},
      idempotencyKey: idempotencyKey,
    );
    return await unwrapObject(response.data, AdminProduct.fromJson) ??
        AdminProduct(id: 0, name: name, categoryId: categoryId);
  });

  @override
  Future<AdminProduct> updateProduct({
    required int id,
    required String name,
  }) => dioGuard(() async {
    final response = await _apiClient.patch(
      '/products/$id',
      data: {'name': name},
    );
    return await unwrapObject(response.data, AdminProduct.fromJson) ??
        AdminProduct(id: id, name: name);
  });

  @override
  Future<void> deleteProduct({required int id}) => dioGuard(() async {
    await _apiClient.delete('/products/$id');
  });

  // ── Variants ──
  @override
  Future<List<AdminVariant>> fetchVariants({required int productId}) =>
      dioGuard(() async {
        final response = await _apiClient.get(
          '/products/$productId/variants',
        );
        return unwrapList(response.data, AdminVariant.fromJson);
      });

  @override
  Future<AdminVariant> createVariant({
    required int productId,
    required String name,
    required int priceKopecks,
    required List<RecipeIngredient> ingredients,
    required String idempotencyKey,
  }) => dioGuard(() async {
    final response = await _apiClient.post(
      '/products/$productId/variants',
      data: {
        'name': name,
        'price': (priceKopecks / 100).toStringAsFixed(2),
        'ingredients': ingredients
            .map(
              (i) => {
                'ingredient_id': i.ingredientId,
                'name': i.name,
                'quantity': i.quantity,
              },
            )
            .toList(),
      },
      idempotencyKey: idempotencyKey,
    );
    return await unwrapObject(response.data, AdminVariant.fromJson) ??
        AdminVariant(id: 0, name: name, priceKopecks: priceKopecks);
  });

  @override
  Future<AdminVariant> updateVariant({
    required int id,
    required String name,
    required int priceKopecks,
  }) => dioGuard(() async {
    final response = await _apiClient.patch(
      '/variants/$id',
      data: {'name': name, 'price': (priceKopecks / 100).toStringAsFixed(2)},
    );
    return await unwrapObject(response.data, AdminVariant.fromJson) ??
        AdminVariant(id: id, name: name, priceKopecks: priceKopecks);
  });

  @override
  Future<void> deleteVariant({required int id}) => dioGuard(() async {
    await _apiClient.delete('/variants/$id');
  });

  // ── Recipe ──
  @override
  Future<List<RecipeIngredient>> fetchRecipe({required int variantId}) =>
      dioGuard(() async {
        final response = await _apiClient.get(
          '/variants/$variantId/recipe',
        );
        return unwrapList(response.data, RecipeIngredient.fromJson);
      });

  @override
  Future<void> replaceRecipe({
    required int variantId,
    required List<RecipeIngredient> ingredients,
  }) => dioGuard(() async {
    final response = await _apiClient.put(
      '/variants/$variantId/recipe',
      data: {
        'ingredients': ingredients
            .map(
              (i) => {
                'ingredient_id': i.ingredientId,
                'name': i.name,
                'quantity': i.quantity,
              },
            )
            .toList(),
      },
    );
    // Backend defect: `PUT /variants/:id/recipe` is a stub whose body is
    // commented out, so it answers `200 {"data":null}` without persisting
    // anything. Reporting that as a success silently drops the edit, so an
    // empty payload is treated as a failure instead.
    if (unwrapData(response.data) == null) {
      throw ApiException(
        'Сервер не зберіг рецепт.',
        code: 'internal_error',
        statusCode: response.statusCode,
      );
    }
  });

  // ── Ingredients & measures ──
  @override
  Future<List<AdminIngredient>> fetchIngredients({required int outletId}) =>
      dioGuard(() async {
        final response = await _apiClient.get(
          '/retail-outlets/$outletId/ingredients',
        );
        return unwrapList(response.data, AdminIngredient.fromJson);
      });

  @override
  Future<List<MeasureUnit>> fetchMeasures() => dioGuard(() async {
    final response = await _apiClient.get('/measure-units');
    return unwrapList(response.data, MeasureUnit.fromJson);
  });
}
