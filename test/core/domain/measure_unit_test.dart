import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/domain/measure_unit.dart';

void main() {
  group('MeasureUnit.fromJson', () {
    test('parses id, name and step', () {
      final unit = MeasureUnit.fromJson(const {
        'id': 5,
        'name': 'кг',
        'step': '0.001',
      });
      expect(unit.id, 5);
      expect(unit.name, 'кг');
      expect(unit.step, Decimal.parse('0.001'));
      expect(unit.scale, 3);
    });

    test('scaleOf counts the fractional digits of the raw step', () {
      expect(MeasureUnit.fromJson(const {'id': 1, 'step': '1'}).scale, 0);
      expect(MeasureUnit.fromJson(const {'id': 1, 'step': '0.001'}).scale, 3);
      expect(MeasureUnit.fromJson(const {'id': 1, 'step': '0.50'}).scale, 2);
    });

    test('normalizes a comma decimal separator before scaling', () {
      final unit = MeasureUnit.fromJson(const {'id': 1, 'step': '0,25'});
      expect(unit.step, Decimal.parse('0.25'));
      expect(unit.scale, 2);
    });

    test('a step missing, empty or malformed falls back to one', () {
      for (final step in [null, '', 'abc'] as List<Object?>) {
        final unit = MeasureUnit.fromJson({'id': 1, 'step': step});
        expect(unit.step, Decimal.one, reason: 'step: $step');
        expect(unit.scale, 0, reason: 'step: $step');
      }
    });

test('a non-positive step falls back to one, scale still reads the raw '
        'string', () {
      for (final step in ['0', '-1', '-0.001']) {
        final unit = MeasureUnit.fromJson({'id': 1, 'step': step});
        expect(unit.step, Decimal.one, reason: 'step: $step');
      }
      // `scale` is derived from the raw text, not from the clamped step.
      expect(
        MeasureUnit.fromJson(const {'id': 1, 'step': '-0.001'}).scale,
        3,
      );
    });

    test('a missing id and name fall back to 0 and the empty string', () {
      final unit = MeasureUnit.fromJson(const {});
      expect(unit.id, 0);
      expect(unit.name, isEmpty);
    });

    test('a numeric step is accepted as well as a string', () {
      expect(
        MeasureUnit.fromJson(const {'id': 1, 'step': 0.25}).step,
        Decimal.parse('0.25'),
      );
    });
  });

  group('equality', () {
    test('units with the same fields are equal', () {
      expect(
        MeasureUnit.fromJson(const {'id': 5, 'name': 'кг', 'step': '0.001'}),
        MeasureUnit.fromJson(const {'id': 5, 'name': 'кг', 'step': '0.001'}),
      );
    });

    test('scale takes part in equality', () {
      final unit = MeasureUnit(id: 1, name: 'шт', step: Decimal.one);
      expect(unit, isNot(unit.copyWith(scale: 2)));
    });
  });

  group('unit helpers', () {
    test('unitStep/unitScale default to piece semantics', () {
      expect(unitStep(null), Decimal.one);
      expect(unitScale(null), 0);
    });

    test('unitStep/unitScale read the unit values', () {
      final unit = MeasureUnit(
        id: 1,
        name: 'кг',
        step: Decimal.parse('0.250'),
        scale: 3,
      );
      expect(unitStep(unit), Decimal.parse('0.250'));
      expect(unitScale(unit), 3);
      expect(formatQuantityValue(Decimal.parse('0.250'), unit), '0.250');
      expect(formatQuantity(Decimal.parse('0.250'), unit), '0.250 кг');
      expect(formatQuantity(Decimal.fromInt(2), null), '2');
    });
  });
}
