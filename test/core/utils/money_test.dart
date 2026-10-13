import 'package:decimal/decimal.dart';
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

  group('kopecksFromDecimal', () {
    // The one conversion between the Decimal cart and the integer money
    // everything downstream uses: exact multiply, round once, half up.
    test('converts exact decimal prices', () {
      expect(kopecksFromDecimal(Decimal.parse('45.50')), 4550);
      expect(kopecksFromDecimal(Decimal.parse('0.07')), 7);
      expect(kopecksFromDecimal(Decimal.parse('0')), 0);
      expect(kopecksFromDecimal(Decimal.parse('35')), 3500);
    });

    test('a cart sum that a double cannot represent is still exact', () {
      // 33.33 × 0.3 + 33.33 × 0.7 + (45 + 25×2) is exactly 128.33; in double
      // arithmetic the same sum prints as 128.32999999999998.
      final exact =
          Decimal.parse('33.33') * Decimal.parse('0.300') +
          Decimal.parse('33.33') * Decimal.parse('0.700') +
          (Decimal.parse('45.00') +
              Decimal.parse('25.00') * Decimal.fromInt(2));
      expect(exact, Decimal.parse('128.33'));
      expect(kopecksFromDecimal(exact), 12833);
    });

    test('keeps the sign on a negative delta total', () {
      expect(kopecksFromDecimal(Decimal.parse('-0.50')), -50);
    });

    test('rounds a half kopeck away from zero', () {
      expect(kopecksFromDecimal(Decimal.parse('0.005')), 1);
      expect(kopecksFromDecimal(Decimal.parse('-0.005')), -1);
    });
  });

  group('uahFromKopecks', () {
    test('is the inverse of kopecksFromDecimal', () {
      for (final kopecks in [0, 5, 50, 3500, 123450, -4550]) {
        expect(
          kopecksFromDecimal(uahFromKopecks(kopecks)),
          kopecks,
          reason: 'kopecks=$kopecks',
        );
      }
    });

    test('keeps two decimals for seed prices', () {
      expect(uahFromKopecks(3500), Decimal.parse('35.00'));
      expect(uahFromKopecks(4050), Decimal.parse('40.50'));
      expect(uahFromKopecks(5), Decimal.parse('0.05'));
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
