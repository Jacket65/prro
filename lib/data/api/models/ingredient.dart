import 'package:equatable/equatable.dart';
import 'package:prro/core/json.dart';

/// Mirrors the backend `dto.IngredientResponse`:
///   { id, name, retail_outlet_id, category_id, unit_id,
///     cost_per_unit, quantity, min_stock_alert }
///
/// `cost_per_unit`, `quantity`, `min_stock_alert` arrive as decimal STRINGS
/// (shopspring/decimal). Parse them via [parseDouble].
class Ingredient extends Equatable {
  const Ingredient({
    required this.id,
    required this.name,
    required this.unitId,
    this.retailOutletId,
    this.categoryId,
    this.costPerUnit = 0,
    this.quantity = 0,
    this.minStockAlert,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: parseInt(json['id']),
      name: (json['name'] ?? '').toString(),
      retailOutletId: json['retail_outlet_id'] == null
          ? null
          : parseInt(json['retail_outlet_id']),
      categoryId: json['category_id'] == null
          ? null
          : parseInt(json['category_id']),
      unitId: parseInt(json['unit_id']),
      costPerUnit: parseDouble(json['cost_per_unit']),
      quantity: parseDouble(json['quantity']),
      minStockAlert: json['min_stock_alert'] == null
          ? null
          : parseDouble(json['min_stock_alert']),
    );
  }
  final int id;
  final String name;
  final int? retailOutletId;
  final int? categoryId;
  final int unitId;
  final double costPerUnit;
  final double quantity;
  final double? minStockAlert;

  @override
  List<Object?> get props => [id, name, unitId];
}
