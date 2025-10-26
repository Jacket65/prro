import 'package:prro/data/api/models/seller_item.dart';

abstract interface class ItemsServiceI implements ItemsRepositoryI {}

abstract interface class ItemsRepositoryI {
  Future<List<Item>> getItemsCategory();
  Future<List<Item>> getItems(int id);
  Future<List<Item>> fetchItems();
  Future<List<Item>> fetchItemsForCategory(Category category);
}
