import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:prro/core/json.dart';
import 'package:prro/core/money.dart';

part 'catalog.freezed.dart';
part 'catalog.g.dart';

int _priceToKopecks(Object? value) {
  if (value == null) return 0;
  final d = value is num
      ? value.toDouble()
      : double.tryParse(value.toString()) ?? 0;
  return uahToKopecks(d);
}

/// A product category within a retail outlet.
///
/// `GET /retail-outlets/{id}/categories` → `{ "data": [ {id, name}, … ] }`.
@freezed
abstract class AdminCategory with _$AdminCategory {
  const factory AdminCategory({
    @JsonKey(fromJson: parseInt) required int id,
    @JsonKey(fromJson: parseString) required String name,
  }) = _AdminCategory;

  factory AdminCategory.fromJson(Map<String, dynamic> json) =>
      _$AdminCategoryFromJson(json);
}

/// A product belonging to a category.
///
/// `GET /categories/{id}/products` → `{ "data": [ {id, name}, … ] }`.
@freezed
abstract class AdminProduct with _$AdminProduct {
  const factory AdminProduct({
    @JsonKey(fromJson: parseInt) required int id,

    @JsonKey(fromJson: parseString) required String name,

    @JsonKey(name: 'category_id', fromJson: parseNullableInt) int? categoryId,
  }) = _AdminProduct;

  factory AdminProduct.fromJson(Map<String, dynamic> json) =>
      _$AdminProductFromJson(json);
}

/// A sellable variant of a product. Price is stored as **kopecks** (int),
/// matching the rest of the app's money convention (money.dart), not `double`
///
/// `GET /products/{id}/variants` → `{ "data": [ {id, name, price}, … ] }`.
@freezed
abstract class AdminVariant with _$AdminVariant {
  const factory AdminVariant({
    @JsonKey(fromJson: parseInt) required int id,

    @JsonKey(fromJson: parseString) required String name,

    @JsonKey(name: 'price', fromJson: _priceToKopecks)
    required int priceKopecks,

    @JsonKey(name: 'product_id', fromJson: parseNullableInt) int? productId,
  }) = _AdminVariant;

  factory AdminVariant.fromJson(Map<String, dynamic> json) =>
      _$AdminVariantFromJson(json);
}

/// An ingredient line in a variant's recipe.
///
/// `GET /variants/{id}/recipe` → `{ "data": [ {ingredient_id, name, quantity}, … ] }`.
@freezed
abstract class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    @JsonKey(name: 'ingredient_id', fromJson: parseInt)
    required int ingredientId,
    @JsonKey(fromJson: parseString) required String name,
    @JsonKey(fromJson: parseDouble) required double quantity,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);
}

/// A raw ingredient available to the outlet (for building recipes).
///
/// `GET /retail-outlets/{id}/ingredients` → `{ "data": [ … ] }`.
@freezed
abstract class AdminIngredient with _$AdminIngredient {
  const factory AdminIngredient({
    @JsonKey(fromJson: parseInt) required int id,
    @JsonKey(fromJson: parseString) required String name,
    @JsonKey(name: 'unit_id', fromJson: parseNullableInt) int? unitId,
  }) = _AdminIngredient;

  factory AdminIngredient.fromJson(Map<String, dynamic> json) =>
      _$AdminIngredientFromJson(json);
}
