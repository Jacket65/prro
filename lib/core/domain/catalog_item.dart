import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/core/utils/json.dart';

part 'catalog_item.freezed.dart';

/// Anything the catalog grid can render: a directly-orderable [Product], a
/// [ProductGroup] that opens a variant picker, or a [Category] that drills
/// down.
///
/// Sealed so a consumer can switch over the three cases exhaustively
/// (`show_item.dart`). It carries no equality of its own — that lives on the
/// three cases, which compare structurally.
sealed class Item {
  const Item._();
}

/// An orderable variant of a product.
///
/// Decoding stays hand-written: a fresh catalog variant starts at one
/// `unitStep(unit)`, a cross-field default no per-field converter can express.
@Freezed(toJson: false)
abstract class Product extends Item with _$Product {
  const factory Product({
    required String id,
    required String name,

    /// Quantity on the order line. Decimal because weight goods sell
    /// fractionally (e.g. `0.250` kg). Stepped by [MeasureUnit.step]; minimum
    /// is one step.
    required Decimal quantity,

    /// Backend ships the price as a decimal STRING ("45.50"); some legacy
    /// paths still ship a number, so the factory accepts both. Kept as a
    /// [Decimal]: a catalog price multiplied by a weight-goods quantity must
    /// not round twice (once in the unit price, once in the line total)
    /// before the cart is billed at kopecks.
    required Decimal price,
    required String imageUrl,

    /// Measure unit of the variant (id/name/step). `null` → piece (step 1).
    MeasureUnit? unit,

    /// Options the cashier picked for this cart line (empty for catalog tiles).
    @Default(<SelectedOption>[]) List<SelectedOption> selectedOptions,

    /// Coffee bean picked for this line, if the drink supports bean selection.
    Bean? selectedBean,
  }) = _Product;

  const Product._() : super._();

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
      name: stringOr(json['name'], ''),
      price: parseDecimal(json['price']),
      imageUrl: stringOr(json['image_url'], ''),
      quantity: quantity,
      unit: unit,
    );
  }

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

  /// Base price plus the sum of selected option surcharges (× portions), all
  /// in exact [Decimal]. Used for the live "Разом"; the authoritative total
  /// comes from the receipt.
  Decimal get effectiveUnitPrice =>
      price +
      selectedOptions.fold(
        Decimal.zero,
        (sum, o) => sum + o.priceDelta * Decimal.fromInt(o.quantity),
      );
}

/// Abstract product (e.g. "Американо") that owns one or more orderable variants
/// Tapping a [ProductGroup] opens a variant picker, not navigate. Variants are
/// carried inline (served by `GET /categories/:id/products`), so the picker
/// needs no extra request.
///
/// Decoding stays hand-written for symmetry with the other two cases.
@Freezed(toJson: false)
abstract class ProductGroup extends Item with _$ProductGroup {
  const factory ProductGroup({
    required int id,
    required String name,
    @Default(<Product>[]) List<Product> variants,
  }) = _ProductGroup;

  const ProductGroup._() : super._();

  factory ProductGroup.fromJson(Map<String, dynamic> json) {
    return ProductGroup(
      id: json['id'] as int,
      name: stringOr(json['name'], ''),
      variants: (json['variants'] as List<dynamic>? ?? const [])
          .whereType<Map<dynamic, dynamic>>()
          .map((v) => Product.fromJson(v.cast<String, dynamic>()))
          .toList(),
    );
  }
}

/// A category of the catalog, holding nested products and categories.
///
/// Decoding stays hand-written: an item is a [Product] or a nested [Category]
/// depending on field *presence* (`containsKey('price')`), not on a named
/// discriminator, so there is no union codegen to lean on.
@Freezed(toJson: false)
abstract class Category extends Item with _$Category {
  const factory Category({
    required int id,
    required String name,
    @Default(<Item>[]) List<Item> items,
  }) = _Category;

  const Category._() : super._();

  factory Category.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? const []).map<Item>((
      itemJson,
    ) {
      final itemMap = (itemJson as Map).cast<String, dynamic>();
      return itemMap.containsKey('price')
          ? Product.fromJson(itemMap)
          : Category.fromJson(itemMap);
    }).toList();
    return Category(
      id: json['id'] as int,
      name: stringOr(json['name'], ''),
      items: items,
    );
  }
}
