import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/items_repository/items_repository.dart';

class ItemsRepository implements ItemsRepositoryI {
  final ItemsServiceI _itemsService;

  ItemsRepository({required ItemsServiceI itemsService})
    : _itemsService = itemsService;

  @override
  Future<List<Item>> getItemsCategory() => _itemsService.getItemsCategory();

  @override
  Future<List<Item>> getItems(int id) => _itemsService.getItems(id);

  @override
  Future<List<Item>> fetchItems() => _itemsService.getItemsCategory();

  @override
  Future<List<Item>> fetchItemsForCategory(Category category) =>
      Future.value(category.items);
}
