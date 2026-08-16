// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retail_outlet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RetailOutlet _$RetailOutletFromJson(Map<String, dynamic> json) =>
    _RetailOutlet(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$RetailOutletToJson(_RetailOutlet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'isActive': instance.isActive,
    };
