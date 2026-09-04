import 'package:decimal/decimal.dart';

/// Tolerant JSON parsing helpers used by API models.
///
/// The backend normally serializes decimal.Decimal values as strings,
/// while legacy/stub endpoints may return plain numbers. These helpers
/// accept both representations and fall back instead of throwing on
/// malformed input.
int? parseNullableInt(Object? value) {
  if (value == null) return null;
  return parseInt(value);
}

double? parseNullableDouble(Object? value) {
  if (value == null) return null;
  return parseDouble(value);
}

String? parseNullableString(Object? value) {
  if (value == null) return null;
  return parseString(value);
}

Decimal? parseNullableDecimal(Object? value) {
  if (value == null) return null;
  return parseDecimal(value);
}

/// Backend uses `shopspring/decimal.Decimal` for prices, quantities, costs,
/// etc., which marshals to JSON as a **string** (e.g. `"45.50"`). At the same
/// time legacy/stub endpoints sometimes return plain numbers. These helpers
/// accept both shapes plus the usual `null` and never throw on bad input —
/// they just fall back to [fallback].

/// Exact decimal parse for quantities/steps (no float drift). Accepts a
/// `Decimal`, `num`, decimal `String`, or `null`; falls back to [fallback]
/// (default `0`).

Decimal parseDecimal(
  Object? value, {
  Decimal? fallback,
}) {
  final fb = fallback ?? Decimal.zero;

  if (value == null) return fb;
  if (value is Decimal) return value;
  if (value is int) return Decimal.fromInt(value);

  final raw = value.toString().trim().replaceAll(',', '.');

  if (raw.isEmpty) return fb;

  try {
    return Decimal.parse(raw);
  } on FormatException {
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
