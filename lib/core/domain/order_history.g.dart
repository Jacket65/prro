// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderListItem _$OrderListItemFromJson(Map<String, dynamic> json) =>
    _OrderListItem(
      orderId: parseInt(orderIdValue(json, 'orderId')),
      createdAt: parseLocalDateTime(json['created_at']),
      totalKopecks: kopecksFromJson(json['total_price']),
    );

_ShiftSummary _$ShiftSummaryFromJson(Map<String, dynamic> json) =>
    _ShiftSummary(
      id: parseInt(json['id']),
      outletId: parseInt(json['outlet_id']),
      openedBy: parseInt(json['opened_by']),
      openedAt: parseLocalDateTime(json['opened_at']),
      status: parseString(json['status']),
      closedBy: parseNullableInt(json['closed_by']),
      closedAt: parseNullableLocalDateTime(json['closed_at']),
      cashEnd: stringOrNull(json['cash_end']),
    );

_OrderDetailItem _$OrderDetailItemFromJson(Map<String, dynamic> json) =>
    _OrderDetailItem(
      name: parseString(json['name']),
      quantity: quantityOrOne(json['quantity']),
      unitPriceKopecks: kopecksFromJson(json['unit_price']),
      lineTotalKopecks: kopecksFromJson(json['line_total']),
      variantId: parseString(json['variant_id']),
      options: json['options'] == null
          ? const <OrderDetailOption>[]
          : orderDetailOptionsFromJson(json['options']),
    );

_OrderDetailOption _$OrderDetailOptionFromJson(Map<String, dynamic> json) =>
    _OrderDetailOption(
      name: parseString(json['name']),
      priceDeltaKopecks: kopecksFromJson(json['price_delta']),
      quantity: quantityOrDefaultOne(json['quantity']),
    );

_OrderDetailPayment _$OrderDetailPaymentFromJson(Map<String, dynamic> json) =>
    _OrderDetailPayment(
      method: paymentMethodFromJson(json['method']),
      tenderedKopecks: kopecksFromJson(json['tendered']),
      changeKopecks: kopecksFromJson(json['change']),
      totalKopecks: kopecksFromJson(json['total']),
    );
