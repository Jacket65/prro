import 'package:flutter_test/flutter_test.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/mock/mock_backend.dart';

void main() {
  late MockBackend backend;

  setUp(() {
    backend = MockBackend.instance;
  });

  test('searchProducts finds items by product name', () async {
    final results = await backend.searchProducts(query: 'Еспресо');
    expect(results.length, 1);
    expect((results.first as Product).name, contains('Еспресо'));
  });

  test('searchProducts finds items by variant name', () async {
    final results = await backend.searchProducts(query: '300 мл');
    // Multi-variant products are returned as ProductGroup with variants
    expect(results.any((item) => item is ProductGroup), isTrue);
    final group = results.whereType<ProductGroup>().first;
    expect(group.name, 'Латте');
    expect(group.variants.any((v) => v.name.contains('300 мл')), isTrue);
  });

  test('searchProducts returns empty for no match', () async {
    final results = await backend.searchProducts(query: 'xyznonexistent');
    expect(results, isEmpty);
  });

  test('searchProducts filters by categoryId', () async {
    final coffeeResults = await backend.searchProducts(
      query: 'Еспресо',
      categoryId: 1, // Coffee category
    );
    expect(coffeeResults.length, 1);
    expect((coffeeResults.first as Product).name, contains('Еспресо'));

    final teaResults = await backend.searchProducts(
      query: 'Еспресо',
      categoryId: 2, // Tea category
    );
    expect(teaResults, isEmpty);
  });

  test('searchProducts trims and lowercases query', () async {
    final results = await backend.searchProducts(query: '  еспресо  ');
    expect(results.length, 1);
    expect((results.first as Product).name, contains('Еспресо'));
  });

  test(
    'searchProducts returns ProductGroup for multi-variant products',
    () async {
      final results = await backend.searchProducts(query: 'Американо');
      expect(results.length, 1);
      expect(results.first, isA<ProductGroup>());
      final group = results.first as ProductGroup;
      expect(group.variants.length, 2);
    },
  );
}
