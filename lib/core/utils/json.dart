import 'package:decimal/decimal.dart';
import 'package:prro/core/utils/money.dart';

/// Tolerant JSON parsing helpers used by API models.
///
/// The backend normally serializes decimal.Decimal values as strings,
/// while legacy/stub endpoints may return plain numbers. These helpers
/// accept both representations and fall back instead of throwing on
/// malformed input.
///
/// The single-argument functions double as `@JsonKey(fromJson:)` converters for
/// the generated freezed decoding, so each one keeps the exact fallback its
/// hand-written predecessor used.
int? parseNullableInt(Object? value) {
  if (value == null) return null;
  return parseInt(value);
}

String? parseNullableString(Object? value) {
  if (value == null) return null;
  return parseString(value);
}

/// `(value ?? fallback).toString()` — the shape the hand-written models used
/// for ids, names and decimal-text quantities. [stringOrEmpty] is the
/// `@JsonKey(fromJson:)`-ready form.
String stringOr(Object? value, String fallback) =>
    (value ?? fallback).toString();

/// [stringOr] with an empty fallback; a missing key yields `''`.
String stringOrEmpty(Object? value) => stringOr(value, '');

/// `value == true` — backend flags are strict booleans, so anything else
/// (including the `"true"` string some stubs send) is not the flag.
bool boolOrFalse(Object? value) => value == true;

/// UAH expressed as a decimal string/number → kopecks, via
/// [kopecksFromString]. A missing key is `0` kopecks.
int kopecksFromJson(Object? value) =>
    kopecksFromString(stringOr(value, '0'));

/// Local-time parse of a backend timestamp, falling back to [fallback]
/// (default: now) for a missing or malformed value. Preserves the
/// `?.toLocal()` behaviour of the hand-written models, including their silent
/// now-fallback.
DateTime parseLocalDateTime(Object? value, {DateTime? fallback}) =>
    DateTime.tryParse(stringOr(value, ''))?.toLocal() ??
    fallback ??
    DateTime.now();

/// Nullable variant of [parseLocalDateTime] for optional timestamps
/// (`closed_at` and friends).
DateTime? parseNullableLocalDateTime(Object? value) =>
    DateTime.tryParse(stringOr(value, ''))?.toLocal();

/// Backend uses `shopspring/decimal.Decimal` for prices, quantities, costs,
/// etc., which marshals to JSON as a **string** (e.g. `"45.50"`). At the same
/// time legacy/stub endpoints sometimes return plain numbers. These helpers
/// accept both shapes plus the usual `null` and never throw on bad input —
/// they just fall back to [fallback].

/// Exact decimal parse for quantities/steps (no float drift). Accepts a
/// `Decimal`, `num`, decimal `String`, or `null`; falls back to [fallback]
/// (default `0`).

Decimal parseDecimal(Object? value, {Decimal? fallback}) {
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

/// The object payload of a backend response, unwrapped from its
/// `{data, error, meta}` envelope.
///
/// Prefers `data` when it is itself an object and otherwise hands back the
/// envelope, so a caller that already tolerates a bare body (the order-history
/// models) keeps working. Returns `null` only when the body carries no object
/// at all — a call site that requires one fails loudly on that `null` rather
/// than defaulting to an empty payload.
///
/// Sibling of `unwrapList`/`unwrapObject` in `core/network/unwrap.dart`; it
/// lives here so `core/domain` can unwrap without reaching into `core/network`.
Map<String, dynamic>? unwrapPayload(Object? raw) {
  if (raw is Map && raw['data'] is Map) {
    return (raw['data'] as Map).cast<String, dynamic>();
  }
  if (raw is Map) return raw.cast<String, dynamic>();
  return null;
}

/// The value of the envelope's `data` key, or [raw] itself when the body is not
/// an envelope.
///
/// Unlike [unwrapPayload] this is *presence*-based, not type-based: a
/// `{"data": null}` body yields `null`. That is what lets a caller detect the
/// backend's stub responses, which answer 200 with an explicitly empty payload.
Object? unwrapData(Object? raw) {
  if (raw is Map && raw.containsKey('data')) return raw['data'];
  return raw;
}
