import 'package:dio/dio.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';

abstract interface class ItemsRepositoryI {
  /// Top-level categories for the current outlet.
  Future<List<Item>> getCategories();

  /// Abstract products inside a category. Returned as [Category]-typed [Item]s
  /// because they are navigable (have no own price).
  Future<List<Item>> getProducts(int categoryId);

  /// Searches products of the current outlet by name
  /// (`GET /retail-outlets/{id}/products?q=...`). Same response shape as
  /// [getProducts] (products with inline variants), so results render with the
  /// existing tiles. Pass a [cancelToken] to abort a superseded search.
  Future<List<Item>> searchProducts({
    required String query,
    int? categoryId,
    CancelToken? cancelToken,
  });

  /// Measure units (`GET /measure-units`). Used to label ingredient quantities
  /// with their unit (г / мл / шт ...).
  Future<List<MeasureUnit>> getMeasureUnits();

  /// Option groups for a drink variant (`GET /variants/:id/options`). Used by
  /// the options picker before adding a drink to the cart. Empty if none.
  Future<List<OptionGroup>> getVariantOptions(int variantId);

  /// Bean groups offered for a drink variant (coffee drinks). Used by the
  /// options picker so the cashier can choose which bean was used. Empty if
  /// the drink doesn't support bean selection.
  Future<List<BeanGroup>> getVariantBeans(int variantId);
}
