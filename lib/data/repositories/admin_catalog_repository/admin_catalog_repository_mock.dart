import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/api/models/measure_unit.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';

@Environment('mock')
@Singleton(as: AdminCatalogRepositoryI)
class AdminCatalogRepositoryMock implements AdminCatalogRepositoryI {
  AdminCatalogRepositoryMock(this._mockBackend);
  final MockBackend _mockBackend;

  @override
  Future<List<AdminCategory>> fetchCategories({required int outletId}) =>
      _mockBackend.getAdminCategories(outletId);

  @override
  Future<AdminCategory> createCategory({
    required int outletId,
    required String name,
    required String idempotencyKey,
  }) => _mockBackend.createAdminCategory(outletId: outletId, name: name);

  @override
  Future<AdminCategory> updateCategory({
    required int id,
    required String name,
  }) => _mockBackend.updateAdminCategory(id: id, name: name);

  @override
  Future<void> deleteCategory({required int id}) =>
      _mockBackend.deleteAdminCategory(id: id);

  @override
  Future<List<AdminProduct>> fetchProducts({required int categoryId}) async =>
      // AdminProduct list is derived from variants in the mock backend; expose
      // thep arent products by reading the catalog shape through variants.
      _mockBackend
          .getAdminVariants(categoryId)
          .then(
            (variants) => variants
                .map((v) => AdminProduct(id: v.productId ?? 0, name: v.name))
                .toList(),
          );

  @override
  Future<AdminProduct> createProduct({
    required int categoryId,
    required String name,
    required String idempotencyKey,
  }) => _mockBackend.createAdminProduct(categoryId: categoryId, name: name);

  @override
  Future<AdminProduct> updateProduct({required int id, required String name}) =>
      _mockBackend.updateAdminProduct(id: id, name: name);

  @override
  Future<void> deleteProduct({required int id}) =>
      _mockBackend.deleteAdminProduct(id: id);

  @override
  Future<List<AdminVariant>> fetchVariants({required int productId}) =>
      _mockBackend.getAdminVariants(productId);

  @override
  Future<AdminVariant> createVariant({
    required int productId,
    required String name,
    required int priceKopecks,
    required List<RecipeIngredient> ingredients,
    required String idempotencyKey,
  }) => _mockBackend.createAdminVariant(
    productId: productId,
    name: name,
    priceKopecks: priceKopecks,
    ingredients: ingredients,
  );

  @override
  Future<AdminVariant> updateVariant({
    required int id,
    required String name,
    required int priceKopecks,
  }) => _mockBackend.updateAdminVariant(
    id: id,
    name: name,
    priceKopecks: priceKopecks,
  );

  @override
  Future<void> deleteVariant({required int id}) =>
      _mockBackend.deleteAdminVariant(id: id);

  @override
  Future<List<RecipeIngredient>> fetchRecipe({required int variantId}) =>
      _mockBackend.getAdminRecipe(variantId);

  @override
  Future<void> replaceRecipe({
    required int variantId,
    required List<RecipeIngredient> ingredients,
  }) => _mockBackend.replaceAdminRecipe(
    variantId: variantId,
    ingredients: ingredients,
  );

  @override
  Future<List<AdminIngredient>> fetchIngredients({
    required int outletId,
  }) => _mockBackend.getAdminIngredients(outletId);

  @override
  Future<List<MeasureUnit>> fetchMeasures() => _mockBackend.getMeasureUnits();
}
