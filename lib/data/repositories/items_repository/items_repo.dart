import 'package:dio/dio.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/ingredient.dart';
import 'package:prro/data/api/models/measure_unit.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/items_repository/items_repository.dart';

class ItemsRepository implements ItemsRepositoryI {

  ItemsRepository({required ItemsServiceI itemsService})
    : _itemsService = itemsService;
  final ItemsServiceI _itemsService;

  @override
  Future<List<Item>> getCategories() => _itemsService.getCategories();

  @override
  Future<List<Item>> getProducts(int categoryId) =>
      _itemsService.getProducts(categoryId);

  @override
  Future<List<Item>> getVariants(int productId) =>
      _itemsService.getVariants(productId);

  @override
  Future<List<Item>> searchProducts({
    required String query,
    int? categoryId,
    CancelToken? cancelToken,
  }) => _itemsService.searchProducts(
    query: query,
    categoryId: categoryId,
    cancelToken: cancelToken,
  );

  @override
  Future<List<Ingredient>> getIngredients() => _itemsService.getIngredients();

  @override
  Future<List<MeasureUnit>> getMeasureUnits() =>
      _itemsService.getMeasureUnits();

  @override
  Future<List<OptionGroup>> getVariantOptions(int variantId) =>
      _itemsService.getVariantOptions(variantId);

  @override
  Future<List<BeanGroup>> getVariantBeans(int variantId) =>
      _itemsService.getVariantBeans(variantId);

  @override
  Future<List<Bean>> getPopularBeans({int limit = 5}) =>
      _itemsService.getPopularBeans(limit: limit);

  @override
  Future<List<Item>> getItemsCategory() => _itemsService.getCategories();

  @override
  Future<List<Item>> fetchItems() => _itemsService.getCategories();

  @override
  Future<List<Item>> fetchItemsForCategory(Category category) =>
      Future.value(category.items);
}
