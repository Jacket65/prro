import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/features/admin/items/variant_detail_cubit.dart';

class MockAdminCatalogRepository extends Mock
    implements AdminCatalogRepositoryI {}

void main() {
  late MockAdminCatalogRepository repository;

  setUp(() {
    repository = MockAdminCatalogRepository();
  });
  registerFallbackValue(
    const RecipeIngredient(ingredientId: 0, name: '', quantity: 0),
  );
  registerFallbackValue(const AdminIngredient(id: 0, name: ''));

  group('VariantDetailCubit', () {
    final recipe = [
      const RecipeIngredient(ingredientId: 1, name: 'Кава', quantity: 2),
    ];
    const ingredients = [
      AdminIngredient(id: 1, name: 'Кава'),
      AdminIngredient(id: 2, name: 'Молоко'),
    ];

    blocTest<VariantDetailCubit, VariantDetailState>(
      'load emits loading then loaded',
      build: () {
        when(() => repository.fetchRecipe(variantId: 1)).thenAnswer(
          (_) async => recipe,
        );
        when(() => repository.fetchIngredients(outletId: 1)).thenAnswer(
          (_) async => ingredients,
        );
        return VariantDetailCubit(repository);
      },
      act: (cubit) => cubit.load(variantId: 1, outletId: 1),
      expect: () => [
        isA<VariantDetailLoading>(),
        isA<VariantDetailLoaded>()
            .having((s) => s.recipe.length, 'recipe', 1)
            .having((s) => s.ingredients.length, 'ingredients', 2),
      ],
    );

    blocTest<VariantDetailCubit, VariantDetailState>(
      'replaceRecipe emits loading then loaded',
      build: () {
        when(
          () => repository.replaceRecipe(
            variantId: 1,
            ingredients: any(named: 'ingredients'),
          ),
        ).thenAnswer((_) async {});
        return VariantDetailCubit(repository);
      },
      seed: () => VariantDetailLoaded(recipe, ingredients),
      act: (cubit) => cubit.replaceRecipe(
        variantId: 1,
        ingredients: const [
          RecipeIngredient(ingredientId: 2, name: 'Молоко', quantity: 1),
        ],
      ),
      expect: () => [
        isA<VariantDetailLoading>(),
        isA<VariantDetailLoaded>().having(
          (s) => s.recipe.length,
          'recipe',
          1,
        ),
      ],
    );

    blocTest<VariantDetailCubit, VariantDetailState>(
      'load emits error on failure',
      build: () {
        when(() => repository.fetchRecipe(variantId: 1)).thenThrow(
          Exception('boom'),
        );
        return VariantDetailCubit(repository);
      },
      act: (cubit) => cubit.load(variantId: 1, outletId: 1),
      expect: () => [
        isA<VariantDetailLoading>(),
        isA<VariantDetailError>(),
      ],
    );
  });
}
