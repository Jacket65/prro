import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/api/models/measure_unit.dart';

/// Catalog administration: categories, products, variants, recipes, ingredients
/// and measure units. All state-changing calls forward a stable
/// idempotencyKey (generated once per modal/screen action) so retries don't
/// double-create.
abstract interface class AdminCatalogRepositoryI {
  // ── Categories (scoped by outlet) ──
  Future<List<AdminCategory>> fetchCategories({required int outletId});
  Future<AdminCategory> createCategory({
    required int outletId,
    required String name,
    required String idempotencyKey,
  });
  Future<AdminCategory> updateCategory({required int id, required String name});
  Future<void> deleteCategory({required int id});

  // ── Products (scoped by category) ──
  Future<List<AdminProduct>> fetchProducts({required int categoryId});
  Future<AdminProduct> createProduct({
    required int categoryId,
    required String name,
    required String idempotencyKey,
  });
  Future<AdminProduct> updateProduct({required int id, required String name});
  Future<void> deleteProduct({required int id});

  // ── Variants (scoped by product) ──
  Future<List<AdminVariant>> fetchVariants({required int productId});
  Future<AdminVariant> createVariant({
    required int productId,
    required String name,
    required int priceKopecks,
    required List<RecipeIngredient> ingredients,
    required String idempotencyKey,
  });
  Future<AdminVariant> updateVariant({
    required int id,
    required String name,
    required int priceKopecks,
  });
  Future<void> deleteVariant({required int id});

  // ── Recipe (scoped by variant) ──
  Future<List<RecipeIngredient>> fetchRecipe({required int variantId});
  Future<void> replaceRecipe({
    required int variantId,
    required List<RecipeIngredient> ingredients,
  });

  // ── Ingredients (scoped by outlet) & measure units ──
  Future<List<AdminIngredient>> fetchIngredients({required int outletId});
  Future<List<MeasureUnit>> fetchMeasures();
}
