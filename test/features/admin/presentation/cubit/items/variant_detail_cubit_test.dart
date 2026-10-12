import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/domain/repositories/admin_catalog_repository_i.dart';
import 'package:prro/features/admin/presentation/cubit/items/variant_detail_cubit.dart';

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
        when(
          () => repository.fetchRecipe(variantId: 1),
        ).thenAnswer((_) async => recipe);
        when(
          () => repository.fetchIngredients(outletId: 1),
        ).thenAnswer((_) async => ingredients);
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
        when(
          () => repository.fetchRecipe(variantId: 1),
        ).thenAnswer((_) async => recipe);
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
        isA<VariantDetailLoaded>().having((s) => s.recipe.length, 'recipe', 1),
      ],
    );

    // F2/R4: the backend stub accepts the write and stores nothing. Emitting
    // the edited list would show a phantom recipe; the emitted state must come
    // from the server, so the admin sees the edit did not stick immediately.
    blocTest<VariantDetailCubit, VariantDetailState>(
      'replaceRecipe emits what the server holds, not the edited list',
      build: () {
        when(
          () => repository.replaceRecipe(
            variantId: 1,
            ingredients: any(named: 'ingredients'),
          ),
        ).thenAnswer((_) async {});
        // The write "succeeded" but the server kept the original recipe.
        when(
          () => repository.fetchRecipe(variantId: 1),
        ).thenAnswer((_) async => recipe);
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
        isA<VariantDetailLoaded>()
            .having((s) => s.recipe.single.name, 'recipe name', 'Кава')
            .having((s) => s.recipe.single.ingredientId, 'ingredient id', 1)
            // The ingredient list for editing is preserved across the save.
            .having((s) => s.ingredients.length, 'ingredients', 2),
      ],
      verify: (_) {
        verify(
          () => repository.replaceRecipe(
            variantId: 1,
            ingredients: any(named: 'ingredients'),
          ),
        ).called(1);
        verify(() => repository.fetchRecipe(variantId: 1)).called(1);
      },
    );

    blocTest<VariantDetailCubit, VariantDetailState>(
      'replaceRecipe emits the new recipe when the server stored it',
      build: () {
        when(
          () => repository.replaceRecipe(
            variantId: 1,
            ingredients: any(named: 'ingredients'),
          ),
        ).thenAnswer((_) async {});
        when(() => repository.fetchRecipe(variantId: 1)).thenAnswer(
          (_) async => const [
            RecipeIngredient(ingredientId: 2, name: 'Молоко', quantity: 3),
          ],
        );
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
        isA<VariantDetailLoaded>()
            .having((s) => s.recipe.single.quantity, 'quantity', 3),
      ],
    );

    blocTest<VariantDetailCubit, VariantDetailState>(
      'replaceRecipe emits error when the write fails',
      build: () {
        when(
          () => repository.replaceRecipe(
            variantId: 1,
            ingredients: any(named: 'ingredients'),
          ),
        ).thenThrow(Exception('boom'));
        return VariantDetailCubit(repository);
      },
      seed: () => VariantDetailLoaded(recipe, ingredients),
      act: (cubit) => cubit.replaceRecipe(
        variantId: 1,
        ingredients: const [
          RecipeIngredient(ingredientId: 2, name: 'Молоко', quantity: 1),
        ],
      ),
      expect: () => [isA<VariantDetailLoading>(), isA<VariantDetailError>()],
    );

    blocTest<VariantDetailCubit, VariantDetailState>(
      'replaceRecipe emits error when the re-read fails, so no stale recipe '
      'is shown',
      build: () {
        when(
          () => repository.replaceRecipe(
            variantId: 1,
            ingredients: any(named: 'ingredients'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => repository.fetchRecipe(variantId: 1),
        ).thenThrow(Exception('read failed'));
        return VariantDetailCubit(repository);
      },
      seed: () => VariantDetailLoaded(recipe, ingredients),
      act: (cubit) => cubit.replaceRecipe(
        variantId: 1,
        ingredients: const [
          RecipeIngredient(ingredientId: 2, name: 'Молоко', quantity: 1),
        ],
      ),
      expect: () => [isA<VariantDetailLoading>(), isA<VariantDetailError>()],
    );

    blocTest<VariantDetailCubit, VariantDetailState>(
      'load emits error on failure',
      build: () {
        when(
          () => repository.fetchRecipe(variantId: 1),
        ).thenThrow(Exception('boom'));
        return VariantDetailCubit(repository);
      },
      act: (cubit) => cubit.load(variantId: 1, outletId: 1),
      expect: () => [isA<VariantDetailLoading>(), isA<VariantDetailError>()],
    );
  });
}
