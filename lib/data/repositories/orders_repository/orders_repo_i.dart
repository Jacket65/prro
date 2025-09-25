import 'package:prro/data/models/models.dart';

abstract interface class OrdersRepositoryI {
  List<Product> get products;
  void addProduct(Product product);
  void removeProduct(Product product);
  void clearProducts();
}
