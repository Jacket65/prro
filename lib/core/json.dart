import 'package:decimal/decimal.dart';

/// Backend uses `shopspring/decimal.Decimal` for prices, quantities, costs,
/// etc., which marshals to JSON as a **string** (e.g. `"45.50"`). At the same
/// time legacy/stub endpoints sometimes return plain numbers. These helpers
/// accept both shapes plus the usual `null` and never throw on bad input —
/// they just fall back to [fallback].

/// Exact decimal parse for quantities/steps (no float drift). Accepts a
/// `Decimal`, `num`, decimal `String`, or `null`; falls back to [fallback]
/// (default `0`).
Decimal parseDecimal(dynamic v, {Decimal? fallback}) {
  final fb = fallback ?? Decimal.zero;
  if (v == null) return fb;
  if (v is Decimal) return v;
  if (v is int) return Decimal.fromInt(v);
  final raw = (v is num ? v.toString() : v.toString()).trim().replaceAll(
    ',',
    '.',
  );
  if (raw.isEmpty) return fb;
  try {
    return Decimal.parse(raw);
  } on Object catch (_) {
    return fb;
  }
}

double parseDouble(dynamic v, {double fallback = 0}) {
  if (v == null) return fallback;
  if (v is num) return v.toDouble();
  if (v is String) {
    final cleaned = v.trim().replaceAll(',', '.');
    if (cleaned.isEmpty) return fallback;
    return double.tryParse(cleaned) ?? fallback;
  }
  return fallback;
}

int parseInt(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) {
    final cleaned = v.trim();
    if (cleaned.isEmpty) return fallback;
    return int.tryParse(cleaned) ??
        double.tryParse(cleaned)?.toInt() ??
        fallback;
  }
  return fallback;
}

/// Tolerant string parse: null/empty → [fallback]. Trims surrounding spaces.
String parseString(dynamic v, {String fallback = ''}) {
  if (v == null) return fallback;
  final s = v.toString().trim();
  return s.isEmpty ? fallback : s;
}
