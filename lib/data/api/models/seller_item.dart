import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:prro/core/json.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/measure_unit.dart';

sealed class Item extends Equatable {
  const Item();
}

final class Product extends Item {
  const Product({
    required this.id,
    required this.quantity,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.unit,
    this.selectedOptions = const [],
    this.selectedBean,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final unit = json['unit'] is Map
        ? MeasureUnit.fromJson((json['unit'] as Map).cast<String, dynamic>())
        : null;
    // A fresh catalog variant starts at one step (the minimum sellable qty);
    // a serialized cart line carries its own quantity.
    final quantity = json['quantity'] == null
        ? unitStep(unit)
        : parseDecimal(json['quantity'], fallback: unitStep(unit));

    return Product(
      id: json['id'].toString(),
      name: (json['name'] ?? '').toString(),
      // Backend ships price as a decimal STRING ("45.50"); some legacy paths
      // still ship a number. parseDouble handles both.
      price: parseDouble(json['price']),
      imageUrl: (json['image_url'] ?? '').toString(),
      quantity: quantity,
      unit: unit,
    );
  }

  final String id;
  final String name;
  final double price;
  final String imageUrl;

  /// Quantity on the order line. Decimal because weight goods sell fractionally
  /// (e.g. `0.250` kg). Stepped by [MeasureUnit.step]; minimum is one step.
  final Decimal quantity;

  /// Measure unit of the variant (id/name/step). `null` → piece (step 1).
  final MeasureUnit? unit;

  /// Options the cashier picked for this cart line (empty for catalog tiles).
  final List<SelectedOption> selectedOptions;

  /// Coffee bean picked for this line, if the drink supports bean selection.
  final Bean? selectedBean;

  /// Stable identity of a cart line: same variant with different options/bean
  /// is a distinct line. Options are sorted by id so order of selection is
  /// irrelevant.
  String get lineId {
    if (selectedOptions.isEmpty && selectedBean == null) return id;
    final parts = [...selectedOptions]
      ..sort((a, b) => a.optionId.compareTo(b.optionId));
    final opts = parts.map((o) => '${o.optionId}x${o.quantity}').join(',');
    final bean = selectedBean == null ? '' : 'b${selectedBean!.id}';
    return '$id#$opts;$bean';
  }

  /// Base price plus the sum of selected option surcharges (× portions).
  /// Used for the live "Разом"; the authoritative total comes from the receipt.
  double get effectiveUnitPrice =>
      price +
      selectedOptions.fold(0.0, (sum, o) => sum + o.priceDelta * o.quantity);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'quantity': quantity.toString(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    Decimal? quantity,
    MeasureUnit? unit,
    List<SelectedOption>? selectedOptions,
    Bean? selectedBean,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      selectedBean: selectedBean ?? this.selectedBean,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    imageUrl,
    quantity,
    unit,
    selectedOptions,
    selectedBean,
  ];
}

/// Abstract product (e.g. "Американо") that owns one or more orderable variants
/// Tapping a [ProductGroup] opens a variant picker, not navigate. Variants are
/// carried inline (served by `GET /categories/:id/products`), so the picker
/// needs no extra request.
final class ProductGroup extends Item {
  const ProductGroup({
    required this.id,
    required this.name,
    this.variants = const [],
  });

  factory ProductGroup.fromJson(Map<String, dynamic> json) {
    return ProductGroup(
      id: json['id'] as int,
      name: (json['name'] ?? '').toString(),
      variants: (json['variants'] as List<dynamic>? ?? const [])
          .whereType<Map<dynamic, dynamic>>()
          .map((v) => Product.fromJson(v.cast<String, dynamic>()))
          .toList(),
    );
  }

  final int id;
  final String name;
  final List<Product> variants;

  @override
  List<Object> get props => [id, name, variants];
}

final class Category extends Item {
  const Category({required this.id, required this.name, this.items = const []});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: (json['name'] ?? '').toString(),
      items: (json['items'] as List<dynamic>? ?? []).map<Item>((itemJson) {
        final itemMap = (itemJson as Map).cast<String, dynamic>();
        if (itemMap.containsKey('price')) {
          return Product.fromJson(itemMap);
        } else {
          return Category.fromJson(itemMap);
        }
      }).toList(),
    );
  }

  final int id;
  final String name;
  final List<Item> items;

  @override
  List<Object?> get props => [id, name, items];
}
