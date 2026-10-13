import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/utils/envelope.dart';
import 'package:prro/core/utils/json.dart';
import 'package:prro/core/utils/money.dart';

part 'order_history.freezed.dart';
part 'order_history.g.dart';

/// A single order as returned by `GET /shifts/{id}/orders` (a page row, not the
/// full receipt). `total_price` is a decimal **string** on the wire, parsed to
/// kopecks via [kopecksFromString].
///
/// The row's identifier arrives as `order_id` (`dto.OrderListItem`); `id` is
/// kept as a legacy fallback so an older payload still resolves, which is why
/// [orderIdValue] reads the whole map instead of naming a single wire key.
@Freezed(toJson: false)
abstract class OrderListItem with _$OrderListItem {
  const factory OrderListItem({
    @JsonKey(readValue: orderIdValue, fromJson: parseInt) required int orderId,
    @JsonKey(name: 'created_at', fromJson: parseLocalDateTime)
    required DateTime createdAt,
    @JsonKey(name: 'total_price', fromJson: kopecksFromJson)
    required int totalKopecks,
  }) = _OrderListItem;

  factory OrderListItem.fromJson(Map<String, dynamic> json) =>
      _$OrderListItemFromJson(json);
}

/// A shift summary as returned by `GET /retail-outlets/{id}/shifts`. Intentionally
/// separate from the current-shift model (ShiftResponse) to avoid clashing
/// field semantics (`cash_end`/`closed_by` vs `cashStart`).
@Freezed(toJson: false)
abstract class ShiftSummary with _$ShiftSummary {
  const factory ShiftSummary({
    @JsonKey(fromJson: parseInt) required int id,
    @JsonKey(name: 'outlet_id', fromJson: parseInt) required int outletId,
    @JsonKey(name: 'opened_by', fromJson: parseInt) required int openedBy,
    @JsonKey(name: 'opened_at', fromJson: parseLocalDateTime)
    required DateTime openedAt,
    @JsonKey(fromJson: parseString) required String status,
    @JsonKey(name: 'closed_by', fromJson: parseNullableInt) int? closedBy,
    @JsonKey(name: 'closed_at', fromJson: parseNullableLocalDateTime)
    DateTime? closedAt,

    /// Decimal text as the backend sent it — not parsed, the history list shows
    /// it verbatim.
    @JsonKey(name: 'cash_end', fromJson: stringOrNull) String? cashEnd,
  }) = _ShiftSummary;

  factory ShiftSummary.fromJson(Map<String, dynamic> json) =>
      _$ShiftSummaryFromJson(json);

  const ShiftSummary._();

  bool get isOpen => status == 'open';
}

/// One line of a historical order's receipt. Mirrors `OrderReceipt` items.
@Freezed(toJson: false)
abstract class OrderDetailItem with _$OrderDetailItem {
  const factory OrderDetailItem({
    @JsonKey(fromJson: parseString) required String name,
    @JsonKey(fromJson: quantityOrOne) required String quantity,
    @JsonKey(name: 'unit_price', fromJson: kopecksFromJson)
    required int unitPriceKopecks,
    @JsonKey(name: 'line_total', fromJson: kopecksFromJson)
    required int lineTotalKopecks,
    @JsonKey(name: 'variant_id', fromJson: parseString)
    required String variantId,
    @JsonKey(fromJson: orderDetailOptionsFromJson)
    @Default(<OrderDetailOption>[])
    List<OrderDetailOption> options,
  }) = _OrderDetailItem;

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailItemFromJson(json);
}

/// A picked option on a receipt line (`OrderReceipt` options).
@Freezed(toJson: false)
abstract class OrderDetailOption with _$OrderDetailOption {
  const factory OrderDetailOption({
    @JsonKey(fromJson: parseString) required String name,
    @JsonKey(name: 'price_delta', fromJson: kopecksFromJson)
    required int priceDeltaKopecks,
    @JsonKey(fromJson: quantityOrDefaultOne) required int quantity,
  }) = _OrderDetailOption;

  factory OrderDetailOption.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailOptionFromJson(json);
}

/// The payment block of a historical order (`OrderReceipt` payment).
@Freezed(toJson: false)
abstract class OrderDetailPayment with _$OrderDetailPayment {
  const factory OrderDetailPayment({
    @JsonKey(fromJson: paymentMethodFromJson) required PaymentMethod method,
    @JsonKey(name: 'tendered', fromJson: kopecksFromJson)
    required int tenderedKopecks,
    @JsonKey(name: 'change', fromJson: kopecksFromJson)
    required int changeKopecks,
    @JsonKey(name: 'total', fromJson: kopecksFromJson)
    required int totalKopecks,
  }) = _OrderDetailPayment;

  factory OrderDetailPayment.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailPaymentFromJson(json);
}

/// The full receipt for a single historical order (`GET /orders/{id}`).
///
/// Decoding stays hand-written: the body may arrive bare or inside a `data`
/// envelope, `payment` defaults to an empty block, and `total_price` falls back
/// to `payment.total`.
@Freezed(toJson: false)
abstract class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required int orderId,
    required int shiftId,
    required String status,
    required DateTime createdAt,
    required int totalKopecks,
    required List<OrderDetailItem> items,
    required OrderDetailPayment payment,
  }) = _OrderDetail;

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    final raw = unwrapPayload(json) ?? json;
    final paymentJson =
        (raw['payment'] as Map?)?.cast<String, dynamic>() ?? const {};
    final items = (raw['items'] as List<dynamic>? ?? const [])
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => OrderDetailItem.fromJson(m.cast<String, dynamic>()))
        .toList();
    return OrderDetail(
      orderId: parseInt(raw['id'] ?? raw['order_id']),
      shiftId: parseInt(raw['shift_id']),
      status: stringOr(raw['status'], ''),
      createdAt: parseLocalDateTime(raw['created_at']),
      totalKopecks: kopecksFromString(
        stringOr(raw['total_price'] ?? paymentJson['total'], '0'),
      ),
      items: items,
      payment: OrderDetailPayment.fromJson(paymentJson),
    );
  }
}

/// A paginated list wrapper matching the `Page` envelope:
/// `{items, page, has_next, next_page}`. The list endpoints are expected to sit
/// inside a `data` envelope (`{data:{...}}`), but [Page.fromJson] also accepts
/// the page object at the top level (falls back to `json` itself).
///
/// Decoding stays hand-written: it takes a per-item decoder, which the
/// generated form cannot carry.
@immutable
class Page<T> {
  const Page({
    required this.items,
    required this.page,
    required this.hasNext,
    this.nextPage,
  });

  factory Page.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    final data = unwrapPayload(json) ?? json;
    final itemsRaw = data['items'] as List<dynamic>? ?? const [];
    final items = itemsRaw
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => fromItem(m.cast<String, dynamic>()))
        .toList();
    return Page<T>(
      items: items,
      page: parseInt(data['page'], fallback: 1),
      hasNext: data['has_next'] == true,
      nextPage: data['next_page'] == null ? null : parseInt(data['next_page']),
    );
  }

  final List<T> items;
  final int page;
  final bool hasNext;
  final int? nextPage;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Page<T>) return false;
    return _listEquals(items, other.items) &&
        page == other.page &&
        hasNext == other.hasNext &&
        nextPage == other.nextPage;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), page, hasNext, nextPage);

  @override
  String toString() =>
      'Page(items: $items, page: $page, hasNext: $hasNext, '
      'nextPage: $nextPage)';
}

/// Element-wise list comparison, so [Page] keeps the value semantics it had via
/// `Equatable.props`.
bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// `order_id` is the wire key, `id` the legacy fallback; the caller chains
/// [parseInt] onto the returned value.
Object? orderIdValue(Map<dynamic, dynamic> json, String key) =>
    json['order_id'] ?? json['id'];

/// Receipt quantities stay decimal text ("2", "0.250"); a missing one means a
/// single portion.
String quantityOrOne(Object? value) => stringOr(value, '1');

/// Same, for the integer option quantity.
int quantityOrDefaultOne(Object? value) => parseInt(value, fallback: 1);

/// [PaymentMethod.fromWire] through the `@JsonKey(fromJson:)` converter shape.
PaymentMethod paymentMethodFromJson(Object? value) =>
    PaymentMethod.fromWire(stringOr(value, ''));

/// Nested options of a receipt line; a missing/non-list key decodes to none.
List<OrderDetailOption> orderDetailOptionsFromJson(Object? value) {
  return (value as List<dynamic>? ?? const [])
      .whereType<Map<dynamic, dynamic>>()
      .map((m) => OrderDetailOption.fromJson(m.cast<String, dynamic>()))
      .toList();
}
