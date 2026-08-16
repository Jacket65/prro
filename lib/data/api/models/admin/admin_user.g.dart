// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => _AdminUser(
  id: parseInt(json['id']),
  name: _nameFromJson(json, 'name') as String,
  phone: parseNullableString(json['phone']),
  email: parseNullableString(json['email']),
  status: _statusFromJson(json['status']),
  role: parseNullableString(json['role']),
);

Map<String, dynamic> _$AdminUserToJson(_AdminUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'status': _$DpsStatusEnumMap[instance.status],
      'role': instance.role,
    };

const _$DpsStatusEnumMap = {
  DpsStatus.registered: 'registered',
  DpsStatus.active: 'active',
  DpsStatus.inactive: 'inactive',
  DpsStatus.blocked: 'blocked',
  DpsStatus.unknown: 'unknown',
};
