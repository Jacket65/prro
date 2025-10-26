import 'dart:async';
// import 'dart:convert';
import 'dart:developer';

import 'package:prro/data/api/api_client.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';

class OrdersRepository implements OrdersRepositoryI {
  final ApiClient _apiClient;

  final List<Product> _products = [];

  OrdersRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  List<Product> get products => List.unmodifiable(_products);

  @override
  double get totalPrice =>
      _products.fold(0.0, (sum, p) => sum + (p.price * p.quantity));

  @override
  void addProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      final existing = _products[index];
      _products[index] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _products.add(product);
    }
  }

  @override
  void removeProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) return;
    final current = _products[index];
    if (current.quantity > 1) {
      _products[index] = current.copyWith(quantity: current.quantity - 1);
    } else {
      _products.removeAt(index);
    }
  }

  @override
  void clearProducts() => _products.clear();

  @override
  Future<void> sell(String paymentMethod) async {
    try {
      final request = {
        "order_details": _products.map((e) => e.toOrderJson()).toList(),
        "payment_method": paymentMethod,
      };
      // final response =
      await _apiClient.dio.post("/seller/order", data: request);
      // final data = jsonDecode(response.data);
      // log("Sell success: $data");
    } catch (e, stack) {
      log("Error in sell(): $e", stackTrace: stack);
      rethrow;
    }
  }
}
