import 'package:dio/dio.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/ingredient.dart';
import 'package:prro/data/api/models/measure_unit.dart';
import 'package:prro/data/api/models/seller_item.dart';

abstract interface class ItemsServiceI implements ItemsRepositoryI {}

abstract interface class ItemsRepositoryI {
  /// Top-level categories for the current outlet.
  Future<List<Item>> getCategories();

  /// Abstract products inside a category. Returned as [Category]-typed [Item]s
  /// because they are navigable (have no own price).
  Future<List<Item>> getProducts(int categoryId);

  /// Concrete variants of an abstract product. Returned as [Product]-typed
  /// [Item]s because each variant is orderable (has a price).
  Future<List<Item>> getVariants(int productId);

  /// Searches products of the current outlet by name
  /// (`GET /retail-outlets/{id}/products?q=...`). Same response shape as
  /// [getProducts] (products with inline variants), so results render with the
  /// existing tiles. Pass a [cancelToken] to abort a superseded search.
  Future<List<Item>> searchProducts({
    required String query,
    int? categoryId,
    CancelToken? cancelToken,
  });

  /// All ingredients available at the current outlet. Used by the recipe
  /// editor in the cart.
  Future<List<Ingredient>> getIngredients();

  /// Measure units (`GET /measure-units`). Used to label ingredient quantities
  /// with their unit (г / мл / шт ...) in the recipe editor.
  Future<List<MeasureUnit>> getMeasureUnits();

  /// Option groups for a drink variant (`GET /variants/:id/options`). Used by
  /// the options picker before adding a drink to the cart. Empty if none.
  Future<List<OptionGroup>> getVariantOptions(int variantId);

  /// Bean groups offered for a drink variant (coffee drinks). Used by the
  /// options picker so the cashier can choose which bean was used. Empty if
  /// the drink doesn't support bean selection.
  Future<List<BeanGroup>> getVariantBeans(int variantId);

  /// Most-used beans first, for the "Часто вживані" shortcut in the bean
  /// picker. (Ideally backend-computed popularity; mocked for now.)
  Future<List<Bean>> getPopularBeans({int limit});

  /// Kept for callers that still want the legacy entry point — returns
  /// root categories.
  Future<List<Item>> getItemsCategory();
  Future<List<Item>> fetchItems();
  Future<List<Item>> fetchItemsForCategory(Category category);
}
