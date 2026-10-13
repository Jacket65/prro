import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';

Product _product({
  Bean? bean,
  List<SelectedOption> options = const [],
  Decimal? quantity,
  Decimal? price,
}) => Product(
  id: 'p1',
  name: 'Кава',
  price: price ?? Decimal.parse('45'),
  imageUrl: 'img',
  quantity: quantity ?? Decimal.one,
  selectedBean: bean,
  selectedOptions: options,
);

void main() {
  group('Product equality', () {
    test('two products with the same fields are equal', () {
      expect(_product(), _product());
      expect(_product().hashCode, _product().hashCode);
    });

    test('a product differing in any field is not equal', () {
      expect(_product(), isNot(_product(quantity: Decimal.fromInt(2))));
      expect(
        _product(),
        isNot(
          _product(
            options: [
              SelectedOption(optionId: 1, name: 'x', priceDelta: Decimal.zero),
            ],
          ),
        ),
      );
      expect(_product(bean: const Bean(id: 1, name: 'x')), isNot(_product()));
    });
  });

  group('Product.fromJson price parsing (F-D)', () {
    test('reads the backend decimal string without touching a double', () {
      final product = Product.fromJson(const {
        'id': 7,
        'name': 'Кава',
        'price': '33.33',
        'image_url': '',
      });

      expect(product.price, Decimal.parse('33.33'));
      expect(product.price.toString(), '33.33');
    });

    test('still accepts the legacy numeric form', () {
      final product = Product.fromJson(const {
        'id': 7,
        'name': 'Кава',
        'price': 45.5,
        'image_url': '',
      });

      expect(product.price, Decimal.parse('45.5'));
    });
  });

  group('Product.effectiveUnitPrice (F-D)', () {
    test('sums multi-option, multi-portion surcharges exactly', () {
      // 45.00 + 25.00×2 + 15.00×1 = 110.00. In double arithmetic the same
      // expression prints 109.99999999999999.
      final product = _product(
        options: [
          SelectedOption(
            optionId: 2,
            name: 'Соєве',
            priceDelta: Decimal.parse('25.00'),
            quantity: 2,
          ),
          SelectedOption(
            optionId: 5,
            name: 'Сироп',
            priceDelta: Decimal.parse('15.00'),
          ),
        ],
      );

      expect(product.effectiveUnitPrice, Decimal.parse('110'));
      // Decimal normalizes trailing zeros; the double sum of the same
      // expression would print 109.99999999999999.
      expect(product.effectiveUnitPrice.toString(), '110');
    });

    test('a price no double can represent stays exact', () {
      // 33.33 + 0.15×3 = 33.78: the double sum is 33.779999999999996.
      final product = _product(
        price: Decimal.parse('33.33'),
        options: [
          SelectedOption(
            optionId: 9,
            name: 'Сироп',
            priceDelta: Decimal.parse('0.15'),
            quantity: 3,
          ),
        ],
      );

      expect(product.effectiveUnitPrice, Decimal.parse('33.78'));
      expect(product.effectiveUnitPrice.toString(), '33.78');
    });
  });

  group('Product.copyWith', () {
    test('selectedBean: null clears the bean', () {
      final product = _product(bean: const Bean(id: 3, name: 'Колумбія'));

      expect(product.copyWith(selectedBean: null).selectedBean, isNull);
    });

    test('omitting selectedBean keeps it', () {
      final product = _product(bean: const Bean(id: 3, name: 'Колумбія'));

      expect(
        product.copyWith(quantity: Decimal.fromInt(2)).selectedBean?.id,
        3,
      );
    });

    test('unit: null clears the unit', () {
      final product = _product().copyWith(
        unit: MeasureUnit(id: 1, name: 'кг', step: Decimal.one),
      );
      expect(product.unit, isNotNull);

      expect(product.copyWith(unit: null).unit, isNull);
    });

    test('replacing a field leaves the others alone', () {
      final product = _product(
        options: [
          SelectedOption(optionId: 2, name: 'Молоко', priceDelta: Decimal.zero),
        ],
      );

      final updated = product.copyWith(quantity: Decimal.fromInt(3));

      expect(updated.quantity, Decimal.fromInt(3));
      expect(updated.selectedOptions, product.selectedOptions);
      expect(updated.id, 'p1');
    });
  });

  group('Product.lineId', () {
    test('is the variant id when nothing is selected', () {
      expect(_product().lineId, 'p1');
    });

    test('includes the options, sorted by id', () {
      final a = _product(
        options: [
          SelectedOption(optionId: 5, name: 'b', priceDelta: Decimal.zero),
          SelectedOption(optionId: 2, name: 'a', priceDelta: Decimal.zero),
        ],
      );
      final b = _product(
        options: [
          SelectedOption(optionId: 2, name: 'a', priceDelta: Decimal.zero),
          SelectedOption(optionId: 5, name: 'b', priceDelta: Decimal.zero),
        ],
      );

      expect(a.lineId, 'p1#2x1,5x1;');
      expect(a.lineId, b.lineId);
    });

    test('includes the bean', () {
      expect(_product(bean: const Bean(id: 3, name: 'x')).lineId, 'p1#;b3');
    });
  });
}
