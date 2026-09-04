import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/features/admin/items/categories_cubit.dart';

class MockAdminCatalogRepository extends Mock
    implements AdminCatalogRepositoryI {}

void main() {
  late MockAdminCatalogRepository repository;

  setUp(() {
    repository = MockAdminCatalogRepository();
  });
  registerFallbackValue(
    const AdminCategory(id: 0, name: ''),
  );
  registerFallbackValue(const AdminProduct(id: 0, name: ''));
  registerFallbackValue('');

  group('CategoriesCubit', () {
    blocTest<CategoriesCubit, CategoriesState>(
      'loadCategories emits loading then loaded',
      build: () {
        when(() => repository.fetchCategories(outletId: 1)).thenAnswer(
          (_) async => const [
            AdminCategory(id: 1, name: 'Кава'),
            AdminCategory(id: 2, name: 'Чай'),
          ],
        );
        return CategoriesCubit(repository);
      },
      act: (cubit) => cubit.loadCategories(outletId: 1),
      expect: () => [
        isA<CategoriesLoading>(),
        isA<CategoriesLoaded>().having((s) => s.categories.length, 'count', 2),
      ],
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'createCategory appends to the list',
      build: () {
        when(() => repository.fetchCategories(outletId: 1)).thenAnswer(
          (_) async => const [AdminCategory(id: 1, name: 'Кава')],
        );
        when(
          () => repository.createCategory(
            outletId: 1,
            name: 'Нове',
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).thenAnswer(
          (_) async => const AdminCategory(id: 9, name: 'Нове'),
        );
        return CategoriesCubit(repository);
      },
      seed: () => const CategoriesLoaded([AdminCategory(id: 1, name: 'Кава')]),
      act: (cubit) => cubit.createCategory(outletId: 1, name: 'Нове'),
      expect: () => [
        isA<CategoriesLoading>(),
        isA<CategoriesLoaded>()
            .having((s) => s.categories.length, 'count', 2)
            .having(
              (s) => s.categories.last.name,
              'last name',
              'Нове',
            ),
      ],
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'renameCategory updates the matching category',
      build: () {
        when(
          () => repository.updateCategory(id: 1, name: 'Кава ROAST'),
        ).thenAnswer(
          (_) async => const AdminCategory(id: 1, name: 'Кава ROAST'),
        );
        return CategoriesCubit(repository);
      },
      seed: () => const CategoriesLoaded([AdminCategory(id: 1, name: 'Кава')]),
      act: (cubit) => cubit.renameCategory(id: 1, name: 'Кава ROAST'),
      expect: () => [
        isA<CategoriesLoading>(),
        isA<CategoriesLoaded>().having(
          (s) => s.categories.first.name,
          'name',
          'Кава ROAST',
        ),
      ],
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'deleteCategory removes the matching category',
      build: () {
        when(() => repository.deleteCategory(id: 1)).thenAnswer(
          (_) async {},
        );
        return CategoriesCubit(repository);
      },
      seed: () => const CategoriesLoaded([
        AdminCategory(id: 1, name: 'Кава'),
        AdminCategory(id: 2, name: 'Чай'),
      ]),
      act: (cubit) => cubit.deleteCategory(id: 1),
      expect: () => [
        isA<CategoriesLoading>(),
        isA<CategoriesLoaded>()
            .having((s) => s.categories.length, 'count', 1)
            .having((s) => s.categories.first.id, 'id', 2),
      ],
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'loadCategories emits error on failure',
      build: () {
        when(() => repository.fetchCategories(outletId: 1)).thenThrow(
          Exception('boom'),
        );
        return CategoriesCubit(repository);
      },
      act: (cubit) => cubit.loadCategories(outletId: 1),
      expect: () => [
        isA<CategoriesLoading>(),
        isA<CategoriesError>(),
      ],
    );
  });
}
