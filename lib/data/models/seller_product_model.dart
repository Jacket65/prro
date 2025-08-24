class Product {
  final String id;
  String name;
  double price;

  Product({required this.id, required this.name, required this.price});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
