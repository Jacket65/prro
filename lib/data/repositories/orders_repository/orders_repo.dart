import 'package:prro/data/models/models.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';

class OrdersRepository implements OrdersRepositoryI {
  final List<Product> _products = [];

  @override
  List<Product> get products => List.unmodifiable(_products);

  @override
  void addProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = _products[index].copyWith(
        quantity: _products[index].quantity + 1,
      );
    } else {
      _products.add(product);
    }
  }

  @override
  void removeProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      final current = _products[index];
      if (current.quantity > 1) {
        _products[index] = current.copyWith(quantity: current.quantity - 1);
      } else {
        _products.removeAt(index);
      }
    }
  }

  @override
  void clearProducts() {
    _products.clear();
  }

  @override
  double get totalPrice {
    return _products.fold(
      0.0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }
}
