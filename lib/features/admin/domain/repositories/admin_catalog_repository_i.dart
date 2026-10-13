import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/features/admin/data/models/catalog.dart';

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
  /// Abstract products inside a category.
  ///
  /// [limit]/[offset] are sent as query parameters when set. They are inert
  /// today — the backend ignores unknown parameters, so no UI pagination is
  /// built on them until the backend ships it (backend gap; see
  /// docs/backend_gaps.md).
  Future<List<AdminProduct>> fetchProducts({
    required int categoryId,
    int? limit,
    int? offset,
  });
  Future<AdminProduct> createProduct({
    required int categoryId,
    required String name,
    required String idempotencyKey,
  });

  /// Kept for contract symmetry: `PATCH /products/:id` exists and is correct,
  /// but no admin UI caller renames a product yet. The call and its tests stay
  /// so the admin panel can add the action without touching the data layer
  /// (see "Known gaps" in CLAUDE.md).
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

  /// The backend does not serve `PATCH /variants/:id` yet — the contract
  /// declares it, the route answers 404. Kept (with the impl and its tests)
  /// so enabling variant renaming/pricing needs no data-layer change; today
  /// the routes are contract-only with no UI caller.
  Future<AdminVariant> updateVariant({
    required int id,
    required String name,
    required int priceKopecks,
  });

  /// Same gap as [updateVariant]: `DELETE /variants/:id` is contract-only (no
  /// route, no UI caller today).
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
