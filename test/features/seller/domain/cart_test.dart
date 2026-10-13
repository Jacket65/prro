import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/seller/domain/cart.dart';

/// The kg weight unit: `unitStep` is 0.250 for it, so a weight line advances in
/// 250-gram steps exactly like the seeded backend products. A null unit is the
/// piece default (step 1).
final _kg = MeasureUnit(id: 1, name: 'кг', step: Decimal.parse('0.250'));

void main() {
  late Cart cart;

  setUp(() {
    cart = Cart();
  });

  Product line({
    required String id,
    required String price,
    required String quantity,
    MeasureUnit? unit,
    List<SelectedOption> options = const [],
  }) => Product(
    id: id,
    name: 'Позиція $id',
    price: Decimal.parse(price),
    quantity: Decimal.parse(quantity),
    unit: unit,
    imageUrl: '',
    selectedOptions: options,
  );

  List<Product> products() => cart.products;

  group('cart total (F-D: exact Decimal pricing)', () {
    test('a fractional-weight, multi-line cart totals exactly', () {
      // 0.300 × 33.33 = 9.999; 0.700 × 33.33 = 23.331;
      // 2 × (45.00 + 25.00×2 portions) = 190.00 → the cart is 223.33, which the
      // double path prints as 223.32999999999998.
      cart
        ..addProduct(
          line(id: 'a', price: '33.33', quantity: '0.300', unit: _kg),
        )
        ..addProduct(
          line(id: 'b', price: '33.33', quantity: '0.700', unit: _kg),
        )
        ..addProduct(
          line(
            id: 'c',
            price: '45.00',
            quantity: '2',
            options: [
              SelectedOption(
                optionId: 2,
                name: 'Соєве',
                priceDelta: Decimal.parse('25.00'),
                quantity: 2,
              ),
            ],
          ),
        );

      expect(products(), hasLength(3));
      expect(cart.totalPrice, Decimal.parse('223.33'));
      expect(cart.totalPrice.toString(), '223.33');

      // The only conversion to kopecks happens at the payment boundary, and it
      // lands exactly on the figure the same lines bill on the wire.
      final totalKopecks = kopecksFromDecimal(cart.totalPrice);
      expect(totalKopecks, 22333);
    });

    test('quantity and price stay Decimal on a weight line', () {
      cart.addProduct(
        line(id: 'kg', price: '19.99', quantity: '0.125', unit: _kg),
      );

      final single = products().single;
      expect(single.quantity, Decimal.parse('0.125'));
      expect(single.price, Decimal.parse('19.99'));
      expect(single.effectiveUnitPrice, Decimal.parse('19.99'));
      // 0.125 × 19.99 = 2.49875 → 250 kopecks, rounded once at the boundary.
      expect(kopecksFromDecimal(cart.totalPrice), 250);
    });

    test('an option price delta is part of the unit price', () {
      cart.addProduct(
        line(
          id: 'p1',
          price: '45.00',
          quantity: '1',
          options: [
            SelectedOption(
              optionId: 2,
              name: 'Молоко',
              priceDelta: Decimal.parse('5.00'),
              quantity: 2,
            ),
          ],
        ),
      );

      // 45.00 + 2 × 5.00 per unit.
      expect(cart.totalPrice, Decimal.parse('55.00'));
      expect(kopecksFromDecimal(cart.totalPrice), 5500);
    });
  });

  group('addProduct / removeProduct', () {
    test('the same lineId stacks by one unit step', () {
      cart
        ..addProduct(line(id: 'a', price: '10', quantity: '1'))
        ..addProduct(line(id: 'a', price: '10', quantity: '1'));

      expect(products().single.quantity, Decimal.fromInt(2));
    });

    test('the same variant with different options is a separate line', () {
      cart
        ..addProduct(line(id: 'a', price: '10', quantity: '1'))
        ..addProduct(
          line(id: 'a', price: '10', quantity: '1', options: options(oId: 2)),
        );

      expect(products(), hasLength(2));
    });

    test('a weight line stacks in its unit step', () {
      cart
        ..addProduct(line(id: 'a', price: '10', quantity: '0.250', unit: _kg))
        ..addProduct(line(id: 'a', price: '10', quantity: '0.250', unit: _kg));

      expect(products().single.quantity, Decimal.parse('0.500'));
    });

    test('removeProduct drops a step and removes the line at the minimum', () {
      cart
        ..addProduct(line(id: 'a', price: '10', quantity: '1'))
        ..addProduct(line(id: 'a', price: '10', quantity: '1'))
        ..addProduct(line(id: 'a', price: '10', quantity: '1'))
        ..removeProduct(line(id: 'a', price: '10', quantity: '1'));

      expect(products().single.quantity, Decimal.fromInt(2));

      cart
        ..removeProduct(line(id: 'a', price: '10', quantity: '1'))
        ..removeProduct(line(id: 'a', price: '10', quantity: '1'));

      expect(products(), isEmpty);
    });

    test('deleteProductLine removes the whole line at once', () {
      cart
        ..addProduct(line(id: 'a', price: '10', quantity: '3'))
        ..deleteProductLine(products().single);

      expect(products(), isEmpty);
    });

    test('removeProduct on an unknown line is a no-op', () {
      cart.removeProduct(line(id: 'zzz', price: '10', quantity: '1'));

      expect(products(), isEmpty);
    });
  });

  group('clear / reset', () {
    test('clearProducts drops the whole cart', () {
      cart
        ..addProduct(line(id: 'a', price: '10', quantity: '1'))
        ..clearProducts();

      expect(products(), isEmpty);
    });

    test('resetForNewSession drops the whole cart', () {
      cart
        ..addProduct(line(id: 'a', price: '10', quantity: '1'))
        ..resetForNewSession();

      expect(products(), isEmpty);
    });

    test('the products view is unmodifiable', () {
      cart.addProduct(line(id: 'a', price: '10', quantity: '1'));

      expect(() => products().clear(), throwsUnsupportedError);
    });
  });

  group('updateOptions', () {
    Product product({Bean? bean, List<SelectedOption> options = const []}) =>
        Product(
          id: 'p1',
          quantity: Decimal.one,
          name: 'Кава',
          price: Decimal.parse('45'),
          imageUrl: '',
          selectedBean: bean,
          selectedOptions: options,
        );

    test('replaces the options of a line', () {
      final line = product();
      cart.addProduct(line);
      final options = [
        SelectedOption(
          optionId: 2,
          name: 'Молоко',
          priceDelta: Decimal.parse('5'),
        ),
      ];

      cart.updateOptions(line.lineId, options);

      expect(products().single.selectedOptions, options);
      expect(products().single.lineId, 'p1#2x1;');
    });

    test('omitting bean drops the bean of the line', () {
      final line = product(bean: const Bean(id: 3, name: 'Колумбія'));
      cart.addProduct(line);
      expect(products().single.selectedBean, isNotNull);

      cart.updateOptions(line.lineId, const []);

      expect(products().single.selectedBean, isNull);
      expect(products().single.lineId, 'p1');
    });

    test('passing a bean sets it on the line', () {
      final line = product();
      cart
        ..addProduct(line)
        ..updateOptions(
          line.lineId,
          const [],
          bean: const Bean(id: 4, name: 'x'),
        );

      expect(products().single.selectedBean?.id, 4);
    });

    test('a quantity replaces the line quantity, null keeps it', () {
      final line = product();
      cart
        ..addProduct(line)
        ..updateOptions(line.lineId, const [], quantity: Decimal.fromInt(3));
      expect(products().single.quantity, Decimal.fromInt(3));

      cart.updateOptions(products().single.lineId, const []);
      expect(products().single.quantity, Decimal.fromInt(3));
    });

    test('changing the options merges into an identical existing line', () {
      final options = [
        SelectedOption(optionId: 2, name: 'Молоко', priceDelta: Decimal.zero),
      ];
      final plain = product();
      cart
        ..addProduct(plain)
        ..addProduct(product(options: options))
        ..updateOptions(plain.lineId, options);

      expect(products(), hasLength(1));
      expect(products().single.selectedOptions, options);
      // The merged line keeps both quantities.
      expect(products().single.quantity, Decimal.fromInt(2));
    });

    test('an unknown lineId is ignored', () {
      cart
        ..addProduct(product())
        ..updateOptions('nope', const []);

      expect(products(), hasLength(1));
    });
  });
}

List<SelectedOption> options({required int oId}) => [
  SelectedOption(optionId: oId, name: 'Опція $oId', priceDelta: Decimal.zero),
];
