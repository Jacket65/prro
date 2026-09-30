// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePaymentRequest _$CreatePaymentRequestFromJson(
  Map<String, dynamic> json,
) => _CreatePaymentRequest(
  amount: (json['amount'] as num).toInt(),
  currency: json['currency'] as String,
  description: json['description'] as String,
  orderId: json['order_id'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CreatePaymentRequestToJson(
  _CreatePaymentRequest instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'currency': instance.currency,
  'description': instance.description,
  'order_id': instance.orderId,
  'metadata': instance.metadata,
};
