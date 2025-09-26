import 'package:prro/data/models/seller_item.dart';

abstract interface class ItemsRepositoryI {
  Future<List<Item>> getItems();
  Future<List<Item>> fetchItems();
  Future<List<Item>> fetchItemsForCategory(Category category);
}
