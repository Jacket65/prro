import 'package:prro/data/models/seller_item.dart';
import 'package:prro/data/services/services.dart';

class ItemsService {
  Future<List<Item>> getProduct() async {
    return listOfCategories;
  }

  Future<List<Item>> fetchItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Sample data
    return [
      Category(
        id: 'cat1',
        name: 'Electronics',
        items: [
          Product(id: 'prod1', name: 'Smartphone', price: 52, imageUrl: ''),
          Product(id: 'prod2', name: 'Laptop', price: 42, imageUrl: ''),
        ],
      ),
      Category(
        id: 'cat2',
        name: 'Clothing',
        items: [
          Product(id: 'prod3', name: 'T-Shirt', price: 32, imageUrl: ''),
          Product(id: 'prod4', name: 'Jeans', price: 22, imageUrl: ''),
        ],
      ),
    ];
  }
}
