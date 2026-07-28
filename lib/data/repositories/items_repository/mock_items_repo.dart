import 'package:dio/dio.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/ingredient.dart';
import 'package:prro/data/api/models/measure_unit.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/repositories/items_repository/items_repository.dart';

class MockItemsRepository implements ItemsRepositoryI {
  MockItemsRepository({MockBackend? backend})
    : _backend = backend ?? MockBackend.instance;
  final MockBackend _backend;

  @override
  Future<List<Item>> getCategories() => _backend.getCategories();

  @override
  Future<List<Item>> getProducts(int categoryId) =>
      _backend.getProducts(categoryId);

  @override
  Future<List<Item>> getItemsCategory() => _backend.getCategories();

  @override
  Future<List<Item>> fetchItems() => _backend.getCategories();

  @override
  Future<List<Item>> fetchItemsForCategory(Category category) =>
      Future.value(category.items);

  @override
  Future<List<Item>> searchProducts({
    required String query,
    int? categoryId,
    CancelToken? cancelToken,
  }) async {
    await _cancelTokenOrDelay(cancelToken);
    return _backend.searchProducts(query: query, categoryId: categoryId);
  }

  @override
  Future<List<Ingredient>> getIngredients() async => const [];

  @override
  Future<List<MeasureUnit>> getMeasureUnits() async =>
      _backend.getMeasureUnits();

  @override
  Future<List<OptionGroup>> getVariantOptions(int variantId) =>
      _backend.getVariantOptions(variantId);

  @override
  Future<List<BeanGroup>> getVariantBeans(int variantId) =>
      _backend.getVariantBeans(variantId);

  @override
  Future<List<Bean>> getPopularBeans({int limit = 5}) =>
      _backend.getPopularBeans(limit: limit);

  @override
  Future<List<Item>> getVariants(int productId) =>
      _backend.getVariants(productId);

  Future<void> _cancelTokenOrDelay(CancelToken? cancelToken) async {
    if (cancelToken?.isCancelled == true) {
      throw DioException(
        requestOptions: RequestOptions(),
        message: 'cancelled',
        type: DioExceptionType.cancel,
      );
    }
  }
}
