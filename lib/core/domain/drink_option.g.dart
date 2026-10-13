// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OptionGroup _$OptionGroupFromJson(Map<String, dynamic> json) => _OptionGroup(
  id: parseInt(groupIdValue(json, 'id')),
  name: parseString(json['name']),
  selectionType: OptionSelectionType.fromJson(json['selection_type']),
  isRequired: json['is_required'] == null
      ? false
      : boolOrFalse(json['is_required']),
  options: json['options'] == null
      ? const <DrinkOption>[]
      : drinkOptionsFromJson(json['options']),
);

_DrinkOption _$DrinkOptionFromJson(Map<String, dynamic> json) => _DrinkOption(
  id: parseInt(optionIdValue(json, 'id')),
  name: parseString(json['name']),
  priceDelta: parseDecimal(json['price_delta']),
  isDefault: json['is_default'] == null
      ? false
      : boolOrFalse(json['is_default']),
);
