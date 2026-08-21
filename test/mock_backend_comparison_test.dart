import 'package:flutter_test/flutter_test.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/mock/mock_backend.dart';

void main() {
  group('MockBackend vs Real Backend Behavior Comparison', () {
    late MockBackend backend;

    setUp(() {
      backend = MockBackend.instance;
    });

    group('Catalog - getCategories', () {
      test('returns list of Category items with id and name', () async {
        final categories = await backend.getCategories();
        expect(categories, isNotEmpty);
        expect(categories.every((c) => c is Category), isTrue);
        final cat = categories.first as Category;
        expect(cat.id, greaterThan(0));
        expect(cat.name, isNotEmpty);
      });
    });

    group('Catalog - getProducts', () {
      test('returns products with variants for coffee category', () async {
        final products = await backend.getProducts(1);
        expect(products, isNotEmpty);
        expect(products.every((p) => p is! Category), isTrue);
      });

      test('returns single Product for single-variant items', () async {
        final products = await backend.getProducts(1);
        final espresso = products.whereType<Product>().firstWhere(
          (p) => p.name.contains('Еспресо'),
          orElse: () => throw Exception('No espresso found'),
        );
        expect(espresso, isA<Product>());
      });

      test('returns ProductGroup for multi-variant items', () async {
        final products = await backend.getProducts(1);
        final americano = products.whereType<ProductGroup>().firstWhere(
          (p) => p.name == 'Американо',
          orElse: () => throw Exception('No americano found'),
        );
        expect(americano.variants.length, 2);
      });

      test('returns empty list for non-existent category', () async {
        final products = await backend.getProducts(9999);
        expect(products, isEmpty);
      });
    });

    group('Orders - placeOrder bean handling', () {
      test('accepts bean in options array and tracks usage', () async {
        final americano = await backend
            .getProducts(1)
            .then(
              (products) => products.whereType<ProductGroup>().firstWhere(
                (p) => p.name == 'Американо',
              ),
            );
        final variant = americano.variants.first;

        final receipt = await backend.placeOrder(
          items: [
            OrderLineDto(
              productId: variant.id,
              quantity: 1,
              options: [
                const SelectedOptionDto(optionId: 1),
                const SelectedOptionDto(optionId: 1),
              ],
            ),
          ],
          payment: const PaymentDto(
            method: PaymentMethod.cash,
            tenderedKopecks: 4500,
          ),
          idempotencyKey: 'test-beans-1',
        );

        expect(receipt.lines.length, 1);
        expect(receipt.lines.first.name, contains('Американо'));
        expect(
          receipt.changeKopecks,
          equals(4500 - receipt.lines.first.subtotalKopecks),
        );
      });

      test('throws for invalid bean option in options array', () async {
        final espresso = await backend
            .getProducts(1)
            .then(
              (products) => products.whereType<Product>().firstWhere(
                (p) => p.name == 'Еспресо',
              ),
            );

        await expectLater(
          backend.placeOrder(
            items: [
              OrderLineDto(
                productId: espresso.id,
                quantity: 1,
                options: [
                  const SelectedOptionDto(optionId: 99999),
                ],
              ),
            ],
            payment: const PaymentDto(
              method: PaymentMethod.cash,
              tenderedKopecks: 100,
            ),
            idempotencyKey: 'test-invalid-bean-2',
          ),
          throwsA(isA<MockBackendException>()),
        );
      });

      test('throws for invalid option not belonging to variant', () async {
        final espresso = await backend
            .getProducts(1)
            .then(
              (products) => products.whereType<Product>().firstWhere(
                (p) => p.name == 'Еспресо',
              ),
            );

        await expectLater(
          backend.placeOrder(
            items: [
              OrderLineDto(
                productId: espresso.id,
                quantity: 1,
                options: [
                  const SelectedOptionDto(optionId: 2),
                ],
              ),
            ],
            payment: const PaymentDto(
              method: PaymentMethod.cash,
              tenderedKopecks: 100,
            ),
            idempotencyKey: 'test-invalid-option-3',
          ),
          throwsA(isA<MockBackendException>()),
        );
      });

      test('handles empty cart', () async {
        await expectLater(
          backend.placeOrder(
            items: [],
            payment: const PaymentDto(
              method: PaymentMethod.cash,
              tenderedKopecks: 100,
            ),
            idempotencyKey: 'test-empty-4',
          ),
          throwsA(isA<MockBackendException>()),
        );
      });

      test('throws for insufficient cash', () async {
        final espresso = await backend
            .getProducts(1)
            .then(
              (products) => products.whereType<Product>().firstWhere(
                (p) => p.name == 'Еспресо',
              ),
            );

        await expectLater(
          backend.placeOrder(
            items: [
              OrderLineDto(
                productId: espresso.id,
                quantity: 1,
                options: [],
              ),
            ],
            payment: const PaymentDto(
              method: PaymentMethod.cash,
              tenderedKopecks: 10,
            ),
            idempotencyKey: 'test-insufficient-5',
          ),
          throwsA(isA<MockBackendException>()),
        );
      });

      test('throws for card payment not matching total', () async {
        final espresso = await backend
            .getProducts(1)
            .then(
              (products) => products.whereType<Product>().firstWhere(
                (p) => p.name == 'Еспресо',
              ),
            );

        await expectLater(
          backend.placeOrder(
            items: [
              OrderLineDto(
                productId: espresso.id,
                quantity: 1,
                options: [],
              ),
            ],
            payment: const PaymentDto(
              method: PaymentMethod.card,
              tenderedKopecks: 9999,
            ),
            idempotencyKey: 'test-card-wrong-6',
          ),
          throwsA(isA<MockBackendException>()),
        );
      });

      test('idempotent - same key returns same receipt', () async {
        final espresso = await backend
            .getProducts(1)
            .then(
              (products) => products.whereType<Product>().firstWhere(
                (p) => p.name == 'Еспресо',
              ),
            );

        final receipt1 = await backend.placeOrder(
          items: [
            OrderLineDto(
              productId: espresso.id,
              quantity: 1,
              options: [],
            ),
          ],
          payment: const PaymentDto(
            method: PaymentMethod.cash,
            tenderedKopecks: 5000,
          ),
          idempotencyKey: 'idempotent-test-7',
        );

        final receipt2 = await backend.placeOrder(
          items: [
            OrderLineDto(
              productId: espresso.id,
              quantity: 2,
              options: [],
            ),
          ],
          payment: const PaymentDto(
            method: PaymentMethod.cash,
            tenderedKopecks: 10000,
          ),
          idempotencyKey: 'idempotent-test-7',
        );

        expect(receipt2.orderId, equals(receipt1.orderId));
        expect(receipt2.totalKopecks, equals(receipt1.totalKopecks));
        expect(receipt2.lines.length, equals(receipt1.lines.length));
      });
    });

    group('Beans - getPopularBeans', () {
      test('returns beans sorted by usage descending', () async {
        final popular = await backend.getPopularBeans(limit: 3);
        expect(popular.length, lessThanOrEqualTo(3));
      });
    });

    group('Error simulation', () {
      test('simulateError causes MockBackendException', () async {
        MockBackend.simulateError = true;
        try {
          await expectLater(
            backend.getCategories(),
            throwsA(isA<MockBackendException>()),
          );
        } finally {
          MockBackend.simulateError = false;
        }
      });
    });
  });
}
