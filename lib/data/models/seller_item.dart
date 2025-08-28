abstract class Item {}

final class Product extends Item {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}

final class Category extends Item {
  final String id;
  final String name;
  final List<Item> items;

  Category({required this.id, required this.name, this.items = const []});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((item) => Category.fromJson(item))
              .toList(),
    );
  }
}
