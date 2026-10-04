// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShiftResponse _$ShiftResponseFromJson(Map<String, dynamic> json) =>
    _ShiftResponse(
      id: parseInt(json['id']),
      outletId: parseInt(json['outlet_id']),
      openedBy: parseInt(json['opened_by']),
      openedAt: stringOrEmpty(json['opened_at']),
      cashStart: cashStartOrZero(json['cash_start']),
      status: parseString(json['status']),
      closedBy: parseNullableInt(json['closed_by']),
      closedAt: stringOrNull(json['closed_at']),
      cashEnd: stringOrNull(json['cash_end']),
    );
