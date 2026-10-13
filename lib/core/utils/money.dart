/// Money is stored everywhere as an `int` of kopecks (1/100 of UAH).
/// Float arithmetic is forbidden for money — use `Money` math instead.
library;

import 'package:decimal/decimal.dart';

/// Convert UAH expressed as `double` (e.g. seed/mock literals like `45.50`)
/// to kopecks without floating-point drift for values with ≤2 decimals.
int uahToKopecks(num uah) => (uah * 100).round();

/// Exact UAH (the [Decimal] the cart works in) → kopecks. This is the one
/// place a cart price reaches money: the multiply is exact and the rounding
/// happens once, here, instead of drifting through a `double` total that is
/// only billed at kopecks.
int kopecksFromDecimal(Decimal uah) =>
    (uah * Decimal.fromInt(100)).round().toBigInt().toInt();

/// The inverse, for seeds and fixtures that think in kopecks: reparsed through
/// [formatAmount] so the decimal is exactly the string the wire uses.
Decimal uahFromKopecks(int kopecks) => Decimal.parse(formatAmount(kopecks));

int kopecksFromString(String raw) {
  final trimmed = raw.trim().replaceAll(',', '.');
  if (trimmed.isEmpty) return 0;
  // The sign has to be read off the string: `int.tryParse('-0')` is 0, so a
  // negative kopeck amount such as "-0.50" would parse as positive.
  final negative = trimmed.startsWith('-');
  final magnitude = negative ? trimmed.substring(1) : trimmed;
  final parts = magnitude.split('.');
  final whole = int.tryParse(parts[0]) ?? 0;
  if (parts.length == 1) return (negative ? -1 : 1) * whole * 100;
  var frac = parts[1];
  if (frac.length == 1) frac = '${frac}0';
  if (frac.length > 2) frac = frac.substring(0, 2);
  final cents = int.tryParse(frac) ?? 0;
  return (negative ? -1 : 1) * (whole * 100 + cents);
}

/// Splits [kopecks] into a sign, whole hryvnias and zero-padded kopecks.
(String, int, String) _splitKopecks(int kopecks) {
  final abs = kopecks.abs();
  final whole = abs ~/ 100;
  final cents = (abs % 100).toString().padLeft(2, '0');
  return (kopecks < 0 ? '-' : '', whole, cents);
}

/// `₴1234.50` — the display form used everywhere in the UI.
String formatUah(int kopecks) {
  final (sign, whole, cents) = _splitKopecks(kopecks);
  return '$sign₴$whole.$cents';
}

/// Bare numeric form `123.45` (no symbol). Useful for filling input fields and
/// for the decimal strings the backend expects on the wire.
String formatAmount(int kopecks) {
  final (sign, whole, cents) = _splitKopecks(kopecks);
  return '$sign$whole.$cents';
}
