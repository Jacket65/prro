import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/features/admin/items/category_detail_cubit.dart';

class MockAdminCatalogRepository extends Mock
    implements AdminCatalogRepositoryI {}

void main() {
  late MockAdminCatalogRepository repository;

  setUp(() {
    repository = MockAdminCatalogRepository();
  });
  registerFallbackValue(
    const AdminProduct(id: 0, name: ''),
  );
  registerFallbackValue('');

  group('CategoryDetailCubit', () {
    blocTest<CategoryDetailCubit, CategoryDetailState>(
      'loadProducts emits loading then loaded',
      build: () {
        when(() => repository.fetchProducts(categoryId: 1)).thenAnswer(
          (_) async => const [
            AdminProduct(id: 1, name: 'Лате'),
            AdminProduct(id: 2, name: 'Капучино'),
          ],
        );
        return CategoryDetailCubit(repository);
      },
      act: (cubit) => cubit.loadProducts(categoryId: 1),
      expect: () => [
        isA<CategoryDetailLoading>(),
        isA<CategoryDetailLoaded>().having(
          (s) => s.products.length,
          'count',
          2,
        ),
      ],
    );

    blocTest<CategoryDetailCubit, CategoryDetailState>(
      'createProduct appends to the list',
      build: () {
        when(() => repository.fetchProducts(categoryId: 1)).thenAnswer(
          (_) async => const [AdminProduct(id: 1, name: 'Лате')],
        );
        when(
          () => repository.createProduct(
            categoryId: 1,
            name: 'Нове',
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).thenAnswer(
          (_) async => const AdminProduct(id: 9, name: 'Нове'),
        );
        return CategoryDetailCubit(repository);
      },
      seed: () =>
          const CategoryDetailLoaded([AdminProduct(id: 1, name: 'Лате')]),
      act: (cubit) => cubit.createProduct(
        categoryId: 1,
        name: 'Нове',
        idempotencyKey: 'key',
      ),
      expect: () => [
        isA<CategoryDetailLoading>(),
        isA<CategoryDetailLoaded>()
            .having((s) => s.products.length, 'count', 2)
            .having((s) => s.products.last.name, 'last name', 'Нове'),
      ],
    );

    blocTest<CategoryDetailCubit, CategoryDetailState>(
      'loadProducts emits error on failure',
      build: () {
        when(() => repository.fetchProducts(categoryId: 1)).thenThrow(
          Exception('boom'),
        );
        return CategoryDetailCubit(repository);
      },
      act: (cubit) => cubit.loadProducts(categoryId: 1),
      expect: () => [
        isA<CategoryDetailLoading>(),
        isA<CategoryDetailError>(),
      ],
    );
  });
}
