import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/domain/repositories/admin_catalog_repository_i.dart';
import 'package:prro/features/admin/presentation/cubit/items/product_detail_cubit.dart';

class MockAdminCatalogRepository extends Mock
    implements AdminCatalogRepositoryI {}

void main() {
  late MockAdminCatalogRepository repository;

  setUp(() {
    repository = MockAdminCatalogRepository();
  });
  registerFallbackValue(const AdminVariant(id: 0, name: '', priceKopecks: 0));
  registerFallbackValue('');

  void stubIngredients() {
    when(() => repository.fetchIngredients(outletId: 1)).thenAnswer(
      (_) async => const [
        AdminIngredient(id: 1, name: 'Кава'),
        AdminIngredient(id: 2, name: 'Молоко'),
      ],
    );
  }

  group('ProductDetailCubit', () {
    blocTest<ProductDetailCubit, ProductDetailState>(
      'loadVariants emits loading then loaded',
      build: () {
        when(() => repository.fetchVariants(productId: 1)).thenAnswer(
          (_) async => const [
            AdminVariant(id: 1, name: 'Малий', priceKopecks: 2500),
            AdminVariant(id: 2, name: 'Великий', priceKopecks: 3500),
          ],
        );
        stubIngredients();
        return ProductDetailCubit(repository);
      },
      act: (cubit) => cubit.loadVariants(productId: 1, outletId: 1),
      expect: () => [
        isA<ProductDetailLoading>(),
        isA<ProductDetailLoaded>()
            .having((s) => s.variants.length, 'count', 2)
            .having((s) => s.ingredients.length, 'ingredients', 2),
      ],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'createVariant forwards a non-empty ingredients list',
      build: () {
        when(() => repository.fetchVariants(productId: 1)).thenAnswer(
          (_) async => const [
            AdminVariant(id: 1, name: 'Малий', priceKopecks: 2500),
          ],
        );
        stubIngredients();
        when(
          () => repository.createVariant(
            productId: 1,
            name: 'Середній',
            priceKopecks: 3000,
            ingredients: any(named: 'ingredients'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).thenAnswer(
          (_) async =>
              const AdminVariant(id: 9, name: 'Середній', priceKopecks: 3000),
        );
        return ProductDetailCubit(repository);
      },
      seed: () => const ProductDetailLoaded([
        AdminVariant(id: 1, name: 'Малий', priceKopecks: 2500),
      ]),
      act: (cubit) => cubit.createVariant(
        productId: 1,
        name: 'Середній',
        priceKopecks: 3000,
        ingredients: const [
          RecipeIngredient(ingredientId: 1, name: 'Кава', quantity: 0.02),
        ],
        idempotencyKey: 'key',
      ),
      expect: () => [
        isA<ProductDetailLoading>(),
        isA<ProductDetailLoaded>()
            .having((s) => s.variants.length, 'count', 2)
            .having((s) => s.variants.last.name, 'last name', 'Середній'),
      ],
      verify: (_) {
        final captured =
            verify(
                  () => repository.createVariant(
                    productId: 1,
                    name: 'Середній',
                    priceKopecks: 3000,
                    ingredients: captureAny(named: 'ingredients'),
                    idempotencyKey: 'key',
                  ),
                ).captured.single
                as List<RecipeIngredient>;
        expect(captured, hasLength(1));
        expect(captured.single.ingredientId, 1);
        expect(captured.single.quantity, 0.02);
      },
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'createVariant keeps the loaded ingredients after a create',
      build: () {
        when(
          () => repository.createVariant(
            productId: 1,
            name: 'Середній',
            priceKopecks: 3000,
            ingredients: any(named: 'ingredients'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).thenAnswer(
          (_) async =>
              const AdminVariant(id: 9, name: 'Середній', priceKopecks: 3000),
        );
        return ProductDetailCubit(repository);
      },
      seed: () => const ProductDetailLoaded(
        [AdminVariant(id: 1, name: 'Малий', priceKopecks: 2500)],
        ingredients: [AdminIngredient(id: 1, name: 'Кава')],
      ),
      act: (cubit) => cubit.createVariant(
        productId: 1,
        name: 'Середній',
        priceKopecks: 3000,
        ingredients: const [
          RecipeIngredient(ingredientId: 1, name: 'Кава', quantity: 1),
        ],
        idempotencyKey: 'key',
      ),
      expect: () => [
        isA<ProductDetailLoading>(),
        isA<ProductDetailLoaded>().having(
          (s) => s.ingredients.length,
          'ingredients',
          1,
        ),
      ],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'loadVariants emits error on failure',
      build: () {
        when(
          () => repository.fetchVariants(productId: 1),
        ).thenThrow(Exception('boom'));
        return ProductDetailCubit(repository);
      },
      act: (cubit) => cubit.loadVariants(productId: 1, outletId: 1),
      expect: () => [isA<ProductDetailLoading>(), isA<ProductDetailError>()],
    );

    test('loadVariants requests both endpoints before awaiting either',
        () async {
      // Guards the concurrency: the ingredient list is independent of the
      // variant list, so awaiting them in sequence doubled the load latency of
      // this screen. `fetchIngredients` must already be in flight while
      // `fetchVariants` is still pending.
      final variants = Completer<List<AdminVariant>>();
      when(
        () => repository.fetchVariants(productId: 1),
      ).thenAnswer((_) => variants.future);
      stubIngredients();

      final cubit = ProductDetailCubit(repository);
      final pending = cubit.loadVariants(productId: 1, outletId: 1);
      await Future<void>.delayed(Duration.zero);

      verify(() => repository.fetchIngredients(outletId: 1)).called(1);

      variants.complete(
        const [AdminVariant(id: 1, name: 'Малиний', priceKopecks: 2500)],
      );
      await pending;
      expect(cubit.state, isA<ProductDetailLoaded>());
      await cubit.close();
    });
  });
}
