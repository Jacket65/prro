import 'package:equatable/equatable.dart';
import 'package:prro/core/json.dart';
import 'package:prro/core/money.dart';
import 'package:prro/data/api/models/order.dart';

/// A single order as returned by `GET /shifts/{id}/orders` (a page row, not the
/// full receipt). `total_price` is a decimal **string** on the wire, parsed to
/// kopecks via [kopecksFromString].
class OrderListItem extends Equatable {
  const OrderListItem({
    required this.orderId,
    required this.createdAt,
    required this.totalKopecks,
  });

  factory OrderListItem.fromJson(Map<String, dynamic> json) {
    return OrderListItem(
      orderId: parseInt(json['id']),
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString())?.toLocal() ??
          DateTime.now(),
      totalKopecks: kopecksFromString((json['total_price'] ?? '0').toString()),
    );
  }

  final int orderId;
  final DateTime createdAt;
  final int totalKopecks;

  @override
  List<Object?> get props => [orderId, createdAt, totalKopecks];
}

/// A shift summary as returned by `GET /retail-outlets/{id}/shifts`. Intentionally
/// separate from the current-shift model (ShiftResponse) to avoid clashing
/// field semantics (`cash_end`/`closed_by` vs `cashStart`).
class ShiftSummary extends Equatable {
  const ShiftSummary({
    required this.id,
    required this.outletId,
    required this.openedBy,
    required this.openedAt,
    required this.status,
    this.closedBy,
    this.closedAt,
    this.cashEnd,
  });

  factory ShiftSummary.fromJson(Map<String, dynamic> json) {
    return ShiftSummary(
      id: parseInt(json['id']),
      outletId: parseInt(json['outlet_id']),
      openedBy: parseInt(json['opened_by']),
      closedBy: json['closed_by'] == null ? null : parseInt(json['closed_by']),
      openedAt:
          DateTime.tryParse((json['opened_at'] ?? '').toString())?.toLocal() ??
          DateTime.now(),
      closedAt: json['closed_at'] == null
          ? null
          : DateTime.tryParse(
              json['closed_at'].toString(),
            )?.toLocal(),
      cashEnd: json['cash_end']?.toString(),
      status: (json['status'] ?? '').toString(),
    );
  }

  final int id;
  final int outletId;
  final int openedBy;
  final DateTime openedAt;
  final int? closedBy;
  final DateTime? closedAt;
  final String? cashEnd;
  final String status;

  bool get isOpen => status == 'open';

  @override
  List<Object?> get props => [
    id,
    outletId,
    openedBy,
    closedBy,
    openedAt,
    closedAt,
    cashEnd,
    status,
  ];
}

/// One line of a historical order's receipt. Mirrors `OrderReceipt` items.
class OrderDetailItem extends Equatable {
  const OrderDetailItem({
    required this.name,
    required this.quantity,
    required this.unitPriceKopecks,
    required this.lineTotalKopecks,
    required this.variantId,
    required this.options,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List<dynamic>? ?? const [])
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (o) => OrderDetailOption.fromJson(o.cast<String, dynamic>()),
        )
        .toList();
    return OrderDetailItem(
      name: (json['name'] ?? '').toString(),
      quantity: (json['quantity'] ?? '1').toString(),
      unitPriceKopecks: kopecksFromString(
        (json['unit_price'] ?? '0').toString(),
      ),
      lineTotalKopecks: kopecksFromString(
        (json['line_total'] ?? '0').toString(),
      ),
      variantId: (json['variant_id'] ?? '').toString(),
      options: options,
    );
  }

  final String name;

  /// Quantity kept as text — backend ships it as a decimal string (e.g. weight
  /// goods may be fractional, like `"0.250"`).
  final String quantity;
  final int unitPriceKopecks;
  final int lineTotalKopecks;
  final String variantId;
  final List<OrderDetailOption> options;

  @override
  List<Object?> get props => [
    name,
    quantity,
    unitPriceKopecks,
    lineTotalKopecks,
    variantId,
    options,
  ];
}

/// A picked option on a receipt line (`OrderReceipt` options).
class OrderDetailOption extends Equatable {
  const OrderDetailOption({
    required this.name,
    required this.priceDeltaKopecks,
    required this.quantity,
  });

  factory OrderDetailOption.fromJson(Map<String, dynamic> json) {
    return OrderDetailOption(
      name: (json['name'] ?? '').toString(),
      priceDeltaKopecks: kopecksFromString(
        (json['price_delta'] ?? '0').toString(),
      ),
      quantity: parseInt(json['quantity'], fallback: 1),
    );
  }

  final String name;
  final int priceDeltaKopecks;
  final int quantity;

  @override
  List<Object?> get props => [name, priceDeltaKopecks, quantity];
}

/// The payment block of a historical order (`OrderReceipt` payment).
class OrderDetailPayment extends Equatable {
  const OrderDetailPayment({
    required this.method,
    required this.tenderedKopecks,
    required this.changeKopecks,
    required this.totalKopecks,
  });

  factory OrderDetailPayment.fromJson(Map<String, dynamic> json) {
    return OrderDetailPayment(
      method: PaymentMethod.fromWire(json['method']?.toString()),
      tenderedKopecks: kopecksFromString((json['tendered'] ?? '0').toString()),
      changeKopecks: kopecksFromString((json['change'] ?? '0').toString()),
      totalKopecks: kopecksFromString((json['total'] ?? '0').toString()),
    );
  }

  final PaymentMethod method;
  final int tenderedKopecks;
  final int changeKopecks;
  final int totalKopecks;

  @override
  List<Object?> get props => [
    method,
    tenderedKopecks,
    changeKopecks,
    totalKopecks,
  ];
}

/// The full receipt for a single historical order (`GET /orders/{id}`).
class OrderDetail extends Equatable {
  const OrderDetail({
    required this.orderId,
    required this.shiftId,
    required this.status,
    required this.createdAt,
    required this.totalKopecks,
    required this.items,
    required this.payment,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] is Map
        ? (json['data'] as Map).cast<String, dynamic>()
        : json;
    final paymentJson =
        (raw['payment'] as Map?)?.cast<String, dynamic>() ?? const {};
    final items = (raw['items'] as List<dynamic>? ?? const [])
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => OrderDetailItem.fromJson(m.cast<String, dynamic>()))
        .toList();
    return OrderDetail(
      orderId: parseInt(raw['id'] ?? raw['order_id']),
      shiftId: parseInt(raw['shift_id']),
      status: (raw['status'] ?? '').toString(),
      createdAt:
          DateTime.tryParse((raw['created_at'] ?? '').toString())?.toLocal() ??
          DateTime.now(),
      totalKopecks: kopecksFromString(
        (raw['total_price'] ?? paymentJson['total'] ?? '0').toString(),
      ),
      items: items,
      payment: OrderDetailPayment.fromJson(paymentJson),
    );
  }

  final int orderId;
  final int shiftId;
  final String status;
  final DateTime createdAt;
  final int totalKopecks;
  final List<OrderDetailItem> items;
  final OrderDetailPayment payment;

  @override
  List<Object?> get props => [
    orderId,
    shiftId,
    status,
    createdAt,
    totalKopecks,
    items,
    payment,
  ];
}

/// A paginated list wrapper matching the `Page` envelope:
/// `{items, page, has_next, next_page}`. The list endpoints are expected to sit
/// inside a `data` envelope (`{data:{...}}`), but [Page.fromJson] also accepts
/// the page object at the top level (falls back to `json` itself).
class Page<T> extends Equatable {
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
    final data = json['data'] is Map
        ? (json['data'] as Map).cast<String, dynamic>()
        : json;
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
  List<Object?> get props => [items, page, hasNext, nextPage];
}
