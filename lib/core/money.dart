/// Money is stored everywhere as an `int` of kopecks (1/100 of UAH).
/// Float arithmetic is forbidden for money — use `Money` math instead.
library;

/// Convert UAH expressed as `double` (e.g. seed/mock literals like `45.50`)
/// to kopecks without floating-point drift for values with ≤2 decimals.
int uahToKopecks(num uah) => (uah * 100).round();

int kopecksFromString(String raw) {
  final trimmed = raw.trim().replaceAll(',', '.');
  if (trimmed.isEmpty) return 0;
  final parts = trimmed.split('.');
  final whole = int.tryParse(parts[0]) ?? 0;
  if (parts.length == 1) return whole * 100;
  var frac = parts[1];
  if (frac.length == 1) frac = '${frac}0';
  if (frac.length > 2) frac = frac.substring(0, 2);
  final cents = int.tryParse(frac) ?? 0;
  return whole * 100 + (whole < 0 ? -cents : cents);
}

String formatUah(int kopecks) {
  final negative = kopecks < 0;
  final abs = kopecks.abs();
  final whole = abs ~/ 100;
  final cents = abs % 100;
  final centsStr = cents.toString().padLeft(2, '0');
  return '${negative ? '-' : ''}₴$whole.$centsStr';
}

/// Bare numeric form `123.45` (no symbol). Useful for filling input fields.
String formatAmount(int kopecks) {
  final negative = kopecks < 0;
  final abs = kopecks.abs();
  final whole = abs ~/ 100;
  final cents = abs % 100;
  return '${negative ? '-' : ''}$whole.${cents.toString().padLeft(2, '0')}';
}
