import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/api/models/measure_unit.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/data/repositories/admin_unwrap.dart';

@Environment('prod')
@Singleton(as: AdminCatalogRepositoryI)
class AdminCatalogRepositoryImpl implements AdminCatalogRepositoryI {
  AdminCatalogRepositoryImpl(this._apiClient);
  final ApiClientI _apiClient;

  // ── Categories ──
  @override
  Future<List<AdminCategory>> fetchCategories({required int outletId}) async {
    try {
      final response = await _apiClient.get(
        '/retail-outlets/$outletId/categories',
      );
      return unwrapList(response.data, AdminCategory.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<AdminCategory> createCategory({
    required int outletId,
    required String name,
    required String idempotencyKey,
  }) async {
    try {
      final response = await _apiClient.post(
        '/retail-outlets/$outletId/categories',
        data: {'name': name},
        idempotencyKey: idempotencyKey,
      );
      return unwrapObject(response.data, AdminCategory.fromJson) ??
          AdminCategory(id: 0, name: name);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<AdminCategory> updateCategory({
    required int id,
    required String name,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/categories/$id',
        data: {'name': name},
      );
      return unwrapObject(response.data, AdminCategory.fromJson) ??
          AdminCategory(id: id, name: name);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> deleteCategory({required int id}) async {
    try {
      await _apiClient.delete('/categories/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ── Products ──
  @override
  Future<List<AdminProduct>> fetchProducts({required int categoryId}) async {
    try {
      final response = await _apiClient.get(
        '/categories/$categoryId/products',
      );
      return unwrapList(response.data, AdminProduct.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<AdminProduct> createProduct({
    required int categoryId,
    required String name,
    required String idempotencyKey,
  }) async {
    try {
      final response = await _apiClient.post(
        '/categories/$categoryId/products',
        data: {'name': name},
        idempotencyKey: idempotencyKey,
      );
      return unwrapObject(response.data, AdminProduct.fromJson) ??
          AdminProduct(id: 0, name: name, categoryId: categoryId);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<AdminProduct> updateProduct({
    required int id,
    required String name,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/products/$id',
        data: {'name': name},
      );
      return unwrapObject(response.data, AdminProduct.fromJson) ??
          AdminProduct(id: id, name: name);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> deleteProduct({required int id}) async {
    try {
      await _apiClient.delete('/products/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ── Variants ──
  @override
  Future<List<AdminVariant>> fetchVariants({required int productId}) async {
    try {
      final response = await _apiClient.get('/products/$productId/variants');
      return unwrapList(response.data, AdminVariant.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<AdminVariant> createVariant({
    required int productId,
    required String name,
    required int priceKopecks,
    required List<RecipeIngredient> ingredients,
    required String idempotencyKey,
  }) async {
    try {
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
      return unwrapObject(response.data, AdminVariant.fromJson) ??
          AdminVariant(id: 0, name: name, priceKopecks: priceKopecks);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<AdminVariant> updateVariant({
    required int id,
    required String name,
    required int priceKopecks,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/variants/$id',
        data: {
          'name': name,
          'price': (priceKopecks / 100).toStringAsFixed(2),
        },
      );
      return unwrapObject(response.data, AdminVariant.fromJson) ??
          AdminVariant(id: id, name: name, priceKopecks: priceKopecks);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> deleteVariant({required int id}) async {
    try {
      await _apiClient.delete('/variants/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ── Recipe ──
  @override
  Future<List<RecipeIngredient>> fetchRecipe({
    required int variantId,
  }) async {
    try {
      final response = await _apiClient.get('/variants/$variantId/recipe');
      return unwrapList(response.data, RecipeIngredient.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> replaceRecipe({
    required int variantId,
    required List<RecipeIngredient> ingredients,
  }) async {
    try {
      await _apiClient.put(
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
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // ── Ingredients & measures ──
  @override
  Future<List<AdminIngredient>> fetchIngredients({
    required int outletId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/retail-outlets/$outletId/ingredients',
      );
      return unwrapList(response.data, AdminIngredient.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<List<MeasureUnit>> fetchMeasures() async {
    try {
      final response = await _apiClient.get('/measure-units');
      return unwrapList(response.data, MeasureUnit.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
