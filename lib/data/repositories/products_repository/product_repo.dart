import 'package:prro/data/models/seller_item.dart';
import 'package:prro/data/repositories/products_repository/products.dart';
import 'package:prro/data/services/product_service.dart';

class ProductRepository implements ProductRepositoryI {
  final ProductService _productService;

  ProductRepository({required ProductService productService})
    : _productService = productService;

  @override
  Future<List<Item>> getProduct() {
    return _productService.getProduct();
  }
}
