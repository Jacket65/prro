import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/items_repository/items_repository.dart';

class MockItemsService extends Mock implements ItemsServiceI {}

void main() {
  late ItemsRepository repository;
  late MockItemsService service;

  setUp(() {
    service = MockItemsService();
    repository = ItemsRepository(itemsService: service);
  });

  test('getCategories returns list from service', () async {
    final categories = [Category(id: 1, name: 'Test', items: [])];

    when(() => service.getCategories()).thenAnswer((_) async => categories);

    final result = await repository.getCategories();

    expect(result, categories);
    verify(() => service.getCategories()).called(1);
  });

  test('getProducts calls service with category id', () async {
    final products = [const ProductGroup(id: 10, name: 'Американо')];

    when(() => service.getProducts(1)).thenAnswer((_) async => products);

    final result = await repository.getProducts(1);

    expect(result, products);
    verify(() => service.getProducts(1)).called(1);
  });

  test('getVariants calls service with product id', () async {
    final variants = [
      Product(
        id: '100',
        name: 'Американо на арабіці',
        price: 55,
        imageUrl: '',
        quantity: Decimal.one,
      ),
    ];

    when(() => service.getVariants(10)).thenAnswer((_) async => variants);

    final result = await repository.getVariants(10);

    expect(result, variants);
    verify(() => service.getVariants(10)).called(1);
  });
}
