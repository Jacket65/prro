import 'package:prro/data/models/seller_item.dart';

abstract interface class ProductRepositoryI {
  Future<List<Item>> getProduct();
}
