import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/features/seller/domain/repositories/items_repository_i.dart';

@Environment('mock')
@Singleton(as: ItemsRepositoryI)
class ItemsRepositoryMock implements ItemsRepositoryI {
  ItemsRepositoryMock(this._backend);
  final MockBackend _backend;

  @override
  Future<List<Item>> getCategories() => _backend.getCategories();

  @override
  Future<List<Item>> getProducts(int categoryId) =>
      _backend.getProducts(categoryId);

  @override
  Future<List<Item>> searchProducts({
    required String query,
    int? categoryId,
    CancelToken? cancelToken,
  }) async {
    if (cancelToken?.isCancelled == true) {
      throw DioException(
        requestOptions: RequestOptions(),
        message: 'cancelled',
        type: DioExceptionType.cancel,
      );
    }
    return await _backend.searchProducts(query: query, categoryId: categoryId);
  }

  @override
  Future<List<MeasureUnit>> getMeasureUnits() async =>
      await _backend.getMeasureUnits();

  @override
  Future<List<OptionGroup>> getVariantOptions(int variantId) =>
      _backend.getVariantOptions(variantId);

  @override
  Future<List<BeanGroup>> getVariantBeans(int variantId) =>
      _backend.getVariantBeans(variantId);
}
