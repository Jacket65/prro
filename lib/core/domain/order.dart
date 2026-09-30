import 'package:prro/core/utils/money.dart';

/// Payment method. `terminal` covers any card/tap payment on the external POS
/// terminal. Wire form is the lowercase string the backend expects: the
/// backend validates `oneof=cash card`, so `terminal` travels as `"card"`.
enum PaymentMethod {
  cash,
  terminal;

  String get wire => switch (this) {
    PaymentMethod.cash => 'cash',
    PaymentMethod.terminal => 'card',
  };

  /// Historic receipts may carry `"card"` or `"nfc"`; both map to [terminal].
  static PaymentMethod fromWire(String? raw) => raw == 'card' || raw == 'nfc'
      ? PaymentMethod.terminal
      : PaymentMethod.cash;
}

// ── Receipt (backend → cart, the authoritative result of POST /orders) ───────

/// One printed line of the receipt. Money is `int` kopecks; the backend ships
/// it as a decimal string, parsed via [kopecksFromString].
class ReceiptLine {
  const ReceiptLine({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPriceKopecks,
    required this.subtotalKopecks,
  });

  /// Maps one entry of the order response `items[]`. Picked option names are
  /// appended to the line name for the printout (beans arrive as options too).
  factory ReceiptLine.fromJson(Map<String, dynamic> json) {
    final base = (json['name'] ?? '').toString();
    final optionNames = (json['options'] as List<dynamic>? ?? const [])
        .whereType<Map<dynamic, dynamic>>()
        .map((o) => (o['name'] ?? '').toString())
        .where((s) => s.isNotEmpty)
        .toList();
    return ReceiptLine(
      productId: (json['variant_id'] ?? '').toString(),
      name: optionNames.isEmpty ? base : '$base · ${optionNames.join(', ')}',
      quantity: (json['quantity'] ?? '1').toString(),
      unitPriceKopecks: kopecksFromString(
        (json['unit_price'] ?? '0').toString(),
      ),
      subtotalKopecks: kopecksFromString(
        (json['line_total'] ?? '0').toString(),
      ),
    );
  }
  final String productId;
  final String name;

  /// Quantity as the backend returned it (decimal string, e.g. "0.250" / "2");
  /// kept as text since it may be fractional for weight goods.
  final String quantity;
  final int unitPriceKopecks;
  final int subtotalKopecks;
}

/// The receipt the cashier sees after a successful sale.
class OrderReceipt {
  const OrderReceipt({
    required this.orderId,
    required this.lines,
    required this.totalKopecks,
    required this.tenderedKopecks,
    required this.changeKopecks,
    required this.method,
    required this.status,
    required this.issuedAt,
    required this.storeName,
    required this.cashierName,
  });

  /// Builds a receipt from the (already-unwrapped) `data` object of a
  /// `POST /retail-outlets/{id}/orders` 201 response.
  factory OrderReceipt.fromJson(
    Map<String, dynamic> json, {
    required String storeName,
    required String cashierName,
  }) {
    final payment =
        (json['payment'] as Map?)?.cast<String, dynamic>() ?? const {};
    final lines = (json['items'] as List<dynamic>? ?? const [])
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => ReceiptLine.fromJson(m.cast<String, dynamic>()))
        .toList();
    return OrderReceipt(
      orderId: (json['order_id'] ?? '').toString(),
      lines: lines,
      totalKopecks: kopecksFromString(
        (json['total_price'] ?? payment['total'] ?? '0').toString(),
      ),
      tenderedKopecks: kopecksFromString(
        (payment['tendered'] ?? '0').toString(),
      ),
      changeKopecks: kopecksFromString((payment['change'] ?? '0').toString()),
      method: PaymentMethod.fromWire(payment['method']?.toString()),
      status: (json['status'] ?? '').toString(),
      issuedAt:
          DateTime.tryParse((json['created_at'] ?? '').toString())?.toLocal() ??
          DateTime.now(),
      storeName: storeName,
      cashierName: cashierName,
    );
  }
  final String orderId;
  final List<ReceiptLine> lines;
  final int totalKopecks;
  final int tenderedKopecks;
  final int changeKopecks;
  final PaymentMethod method;
  final String status;
  final DateTime issuedAt;

  /// Header info for the printout. The order response carries neither, so the
  /// caller supplies them (store from config, cashier from the session).
  final String storeName;
  final String cashierName;

  @override
  String toString() =>
      'OrderReceipt($orderId, total=${formatUah(totalKopecks)}, '
      'change=${formatUah(changeKopecks)}, method=$method, $status)';
}
