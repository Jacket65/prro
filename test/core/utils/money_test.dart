import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/utils/money.dart';

void main() {
  group('uahToKopecks', () {
    test('converts without float drift', () {
      expect(uahToKopecks(45.5), 4550);
      expect(uahToKopecks(0.1), 10);
      expect(uahToKopecks(1234), 123400);
    });
  });

  group('kopecksFromString', () {
    test('reads the decimal strings the backend sends', () {
      expect(kopecksFromString('45.50'), 4550);
      expect(kopecksFromString('45.5'), 4550);
      expect(kopecksFromString('45'), 4500);
      expect(kopecksFromString('0.07'), 7);
    });

    test('accepts a comma decimal separator', () {
      expect(kopecksFromString('45,50'), 4550);
    });

    test('keeps the sign on the fractional part', () {
      expect(kopecksFromString('-45.50'), -4550);
      expect(kopecksFromString('-0.50'), -50);
    });

    test('falls back to zero on malformed input', () {
      expect(kopecksFromString(''), 0);
      expect(kopecksFromString('abc'), 0);
    });
  });

  group('formatUah', () {
    test('renders whole hryvnias with two decimals and a symbol', () {
      expect(formatUah(123450), '₴1234.50');
      expect(formatUah(5), '₴0.05');
      expect(formatUah(0), '₴0.00');
    });

    test('keeps the sign outside the symbol', () {
      expect(formatUah(-4550), '-₴45.50');
    });
  });

  group('formatAmount', () {
    test('renders the same number without the symbol', () {
      expect(formatAmount(123450), '1234.50');
      expect(formatAmount(5), '0.05');
      expect(formatAmount(-4550), '-45.50');
    });

    test('agrees with formatUah on the numeric part', () {
      for (final kopecks in [0, 1, 99, 100, 4550, 123450, -4550]) {
        expect(
          formatAmount(kopecks),
          formatUah(kopecks).replaceFirst('₴', ''),
          reason: 'kopecks=$kopecks',
        );
      }
    });
  });
}
