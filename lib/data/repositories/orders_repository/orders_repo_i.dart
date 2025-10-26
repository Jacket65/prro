import 'package:prro/data/api/models/models.dart';

abstract interface class OrdersRepositoryI {
  List<Product> get products;
  double get totalPrice;
  void addProduct(Product product);
  void removeProduct(Product product);
  void clearProducts();

  Future<void> sell(String paymentMethod);
}
