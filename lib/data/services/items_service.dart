import 'dart:convert';
import 'dart:developer';

import 'package:prro/data/api/api_client.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/items_repository/items_repo_i.dart';
// import 'package:prro/data/services/services.dart';

class ItemsService implements ItemsServiceI {
  final ApiClient _apiClient;

  ItemsService({required ApiClient apiClient}) : _apiClient = apiClient;
  @override
  Future<List<Item>> getItemsCategory() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await _apiClient.get("/seller/categories");

      final List<dynamic> data = jsonDecode(response.data)['data'];

      final List<Category> listOfCategories = data
          .map((json) => Category.fromJson(json))
          .toList();

      return listOfCategories;
    } catch (e, stackTrace) {
      log("Error in getItems: $e", stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<Item>> getItems(int id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await _apiClient.get("/seller/category/$id");

      final List<dynamic> data = jsonDecode(response.data)['data'];

      final List<Item> listOfItems = data
          .map((json) => Product.fromJson(json))
          .toList();

      return listOfItems;
    } catch (e, stackTrace) {
      log("Error in getItems: $e", stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<Item>> fetchItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Sample data
    return [
      Category(
        id: 1,
        name: 'Electronics',
        items: [
          Product(id: 'prod1', name: 'Smartphone', price: 52, imageUrl: ''),
          Product(id: 'prod2', name: 'Laptop', price: 42, imageUrl: ''),
        ],
      ),
      Category(
        id: 2,
        name: 'Clothing',
        items: [
          Product(id: 'prod3', name: 'T-Shirt', price: 32, imageUrl: ''),
          Product(id: 'prod4', name: 'Jeans', price: 22, imageUrl: ''),
        ],
      ),
    ];
  }

  @override
  Future<List<Item>> fetchItemsForCategory(Category category) {
    return Future.value(category.items);
  }
}
