import 'package:prro/data/models/seller_item.dart';
import 'package:prro/data/repositories/items_repository/items_repository.dart';
import 'package:prro/data/services/items_service.dart';

class ItemsRepository implements ItemsRepositoryI {
  final ItemsService _productService;

  ItemsRepository({required ItemsService productService})
    : _productService = productService;

  @override
  Future<List<Item>> getItems() {
    return _productService.getItems();
  }

  @override
  Future<List<Item>> fetchItems() {
    return _productService.fetchItems();
  }

  @override
  Future<List<Item>> fetchItemsForCategory(Category category) {
    return Future.value(category.items);
  }
}
