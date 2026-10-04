// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bean _$BeanFromJson(Map<String, dynamic> json) =>
    _Bean(id: parseInt(json['id']), name: parseString(json['name']));

_BeanGroup _$BeanGroupFromJson(Map<String, dynamic> json) => _BeanGroup(
  id: parseInt(json['id']),
  name: parseString(json['name']),
  beans: json['beans'] == null ? const <Bean>[] : beansFromJson(json['beans']),
);
