import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/utils/json.dart';
import 'package:prro/core/utils/money.dart';

part 'order.freezed.dart';

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
///
/// Decoding stays hand-written: the picked option names are folded into [name],
/// which no per-field converter can express.
@Freezed(toJson: false)
abstract class ReceiptLine with _$ReceiptLine {
  const factory ReceiptLine({
    required String productId,
    required String name,

    /// Quantity as the backend returned it (decimal string, e.g. "0.250" / "2");
    /// kept as text since it may be fractional for weight goods.
    required String quantity,
    required int unitPriceKopecks,
    required int subtotalKopecks,
  }) = _ReceiptLine;

  /// Maps one entry of the order response `items[]`. Picked option names are
  /// appended to the line name for the printout (beans arrive as options too).
  factory ReceiptLine.fromJson(Map<String, dynamic> json) {
    final base = stringOr(json['name'], '');
    final optionNames = (json['options'] as List<dynamic>? ?? const [])
        .whereType<Map<dynamic, dynamic>>()
        .map((o) => stringOr(o['name'], ''))
        .where((s) => s.isNotEmpty)
        .toList();
    return ReceiptLine(
      productId: stringOr(json['variant_id'], ''),
      name: optionNames.isEmpty ? base : '$base · ${optionNames.join(', ')}',
      quantity: stringOr(json['quantity'], '1'),
      unitPriceKopecks: kopecksFromString(stringOr(json['unit_price'], '0')),
      subtotalKopecks: kopecksFromString(stringOr(json['line_total'], '0')),
    );
  }
}

/// The receipt the cashier sees after a successful sale.
///
/// Decoding stays hand-written: `fromJson` takes the local-only store/cashier
/// names, which the order response does not carry.
@Freezed(toJson: false)
abstract class OrderReceipt with _$OrderReceipt {
  const factory OrderReceipt({
    required String orderId,
    required List<ReceiptLine> lines,
    required int totalKopecks,
    required int tenderedKopecks,
    required int changeKopecks,
    required PaymentMethod method,
    required String status,
    required DateTime issuedAt,

    /// Header info for the printout. The order response carries neither, so the
    /// caller supplies them (store from config, cashier from the session).
    required String storeName,
    required String cashierName,
  }) = _OrderReceipt;

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
      orderId: stringOr(json['order_id'], ''),
      lines: lines,
      totalKopecks: kopecksFromString(
        stringOr(json['total_price'] ?? payment['total'], '0'),
      ),
      tenderedKopecks: kopecksFromString(stringOr(payment['tendered'], '0')),
      changeKopecks: kopecksFromString(stringOr(payment['change'], '0')),
      method: PaymentMethod.fromWire(stringOrNull(payment['method'])),
      status: stringOr(json['status'], ''),
      issuedAt: parseLocalDateTime(json['created_at']),
      storeName: storeName,
      cashierName: cashierName,
    );
  }
}
