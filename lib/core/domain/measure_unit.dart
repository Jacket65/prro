import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/utils/json.dart';

part 'measure_unit.freezed.dart';

/// Mirrors the backend measure unit carried by a variant:
///   { "id": 5, "name": "кг", "step": "0.001" }
///
/// `step` is the quantity increment (decimal STRING). [scale] is the number of
/// fractional digits implied by it ("1" → 0, "0.001" → 3), used for display and
/// rounding. A `null` unit elsewhere means piece semantics (step 1, scale 0).
///
/// Decoding stays hand-written: [scale] is derived from the *raw* `step` string
/// (so a `"0.50"` step scales to 2 even though `Decimal` would normalise it),
/// which a per-field converter cannot express.
@Freezed(toJson: false)
abstract class MeasureUnit with _$MeasureUnit {
  const factory MeasureUnit({
    required int id,
    required String name,
    required Decimal step,
    @Default(0) int scale,
  }) = _MeasureUnit;

  factory MeasureUnit.fromJson(Map<String, dynamic> json) {
    final raw = stringOr(json['step'], '1').trim().replaceAll(',', '.');
    var step = parseDecimal(raw, fallback: Decimal.one);
    if (step <= Decimal.zero) step = Decimal.one;
    return MeasureUnit(
      id: parseInt(json['id']),
      name: stringOr(json['name'], ''),
      step: step,
      scale: scaleOf(raw),
    );
  }

  /// Fractional-digit count implied by a raw `step` string.
  static int scaleOf(String raw) {
    final dot = raw.indexOf('.');
    if (dot < 0) return 0;
    return raw.length - dot - 1;
  }
}

/// Quantity step for a (possibly null) unit — `1` for piece/null.
Decimal unitStep(MeasureUnit? unit) => unit?.step ?? Decimal.one;

/// Fractional-digit precision for a (possibly null) unit — `0` for piece/null.
int unitScale(MeasureUnit? unit) => unit?.scale ?? 0;

/// Bare numeric quantity at the unit's precision: "0.250", "2".
String formatQuantityValue(Decimal qty, MeasureUnit? unit) =>
    qty.toStringAsFixed(unitScale(unit));

/// Quantity with its unit label: "0.250 кг", "2 порц", "3 шт". For a null unit
/// the label is omitted (plain piece count).
String formatQuantity(Decimal qty, MeasureUnit? unit) {
  final value = formatQuantityValue(qty, unit);
  final label = unit?.name ?? '';
  return label.isEmpty ? value : '$value $label';
}
