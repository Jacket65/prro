import 'package:equatable/equatable.dart';

abstract class Item extends Equatable {
  const Item();
}

final class Product extends Item {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  const Product({
    required this.id,
    this.quantity = 1,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
      quantity: (json['quantity'] ?? 0),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [id, name, price, imageUrl, quantity];
}

final class Category extends Item {
  final String id;
  final String name;
  final List<Item> items;

  const Category({required this.id, required this.name, this.items = const []});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      items: (json['items'] as List<dynamic>? ?? []).map<Item>((itemJson) {
        if (itemJson.containsKey('price')) {
          return Product.fromJson(itemJson);
        } else {
          return Category.fromJson(itemJson);
        }
        //: Варіант 2: якщо в JSON є поле 'type'
        // switch (itemJson['type']) {
        //   case 'product':
        //     return Product.fromJson(itemJson);
        //   case 'category':
        //   default:
        //     return Category.fromJson(itemJson);
        // }
      }).toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, items];
}
