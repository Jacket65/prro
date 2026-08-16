// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminCategory _$AdminCategoryFromJson(Map<String, dynamic> json) =>
    _AdminCategory(id: parseInt(json['id']), name: parseString(json['name']));

Map<String, dynamic> _$AdminCategoryToJson(_AdminCategory instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_AdminProduct _$AdminProductFromJson(Map<String, dynamic> json) =>
    _AdminProduct(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      categoryId: _nullableIntFromJson(json['category_id']),
    );

Map<String, dynamic> _$AdminProductToJson(_AdminProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category_id': instance.categoryId,
    };

_AdminVariant _$AdminVariantFromJson(Map<String, dynamic> json) =>
    _AdminVariant(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      priceKopecks: _priceToKopecks(json['price']),
      productId: _nullableIntFromJson(json['product_id']),
    );

Map<String, dynamic> _$AdminVariantToJson(_AdminVariant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.priceKopecks,
      'product_id': instance.productId,
    };

_RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) =>
    _RecipeIngredient(
      ingredientId: parseInt(json['ingredient_id']),
      name: parseString(json['name']),
      quantity: parseDouble(json['quantity']),
    );

Map<String, dynamic> _$RecipeIngredientToJson(_RecipeIngredient instance) =>
    <String, dynamic>{
      'ingredient_id': instance.ingredientId,
      'name': instance.name,
      'quantity': instance.quantity,
    };

_AdminIngredient _$AdminIngredientFromJson(Map<String, dynamic> json) =>
    _AdminIngredient(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      unitId: _nullableIntFromJson(json['unit_id']),
    );

Map<String, dynamic> _$AdminIngredientToJson(_AdminIngredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit_id': instance.unitId,
    };
