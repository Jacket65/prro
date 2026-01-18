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

  test('getItemsCategory returns list from service', () async {
    final categories = [Category(id: 1, name: 'Test', items: [])];

    when(() => service.getItemsCategory()).thenAnswer((_) async => categories);

    final result = await repository.getItemsCategory();

    expect(result, categories);
    verify(() => service.getItemsCategory()).called(1);
  });

  test('getItems calls service with id', () async {
    final items = [Product(id: '1', name: 'Item', price: 10, imageUrl: '')];

    when(() => service.getItems(1)).thenAnswer((_) async => items);

    final result = await repository.getItems(1);

    expect(result, items);
    verify(() => service.getItems(1)).called(1);
  });
}
