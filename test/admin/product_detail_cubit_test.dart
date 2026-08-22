import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/features/admin/items/product_detail_cubit.dart';

class MockAdminCatalogRepository extends Mock
    implements AdminCatalogRepositoryI {}

void main() {
  late MockAdminCatalogRepository repository;

  setUp(() {
    repository = MockAdminCatalogRepository();
  });
  registerFallbackValue(
    const AdminVariant(id: 0, name: '', priceKopecks: 0),
  );
  registerFallbackValue('');

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
        return ProductDetailCubit(repository);
      },
      act: (cubit) => cubit.loadVariants(productId: 1),
      expect: () => [
        isA<ProductDetailLoading>(),
        isA<ProductDetailLoaded>()
            .having((s) => s.variants.length, 'count', 2),
      ],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'createVariant appends to the list',
      build: () {
        when(() => repository.fetchVariants(productId: 1)).thenAnswer(
          (_) async => const [
            AdminVariant(id: 1, name: 'Малий', priceKopecks: 2500),
          ],
        );
        when(
          () => repository.createVariant(
            productId: 1,
            name: 'Середній',
            priceKopecks: 3000,
            ingredients: any(named: 'ingredients'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).thenAnswer(
          (_) async => const AdminVariant(
            id: 9,
            name: 'Середній',
            priceKopecks: 3000,
          ),
        );
        return ProductDetailCubit(repository);
      },
      seed: () => const ProductDetailLoaded(
        [AdminVariant(id: 1, name: 'Малий', priceKopecks: 2500)],
      ),
      act: (cubit) => cubit.createVariant(
        productId: 1,
        name: 'Середній',
        priceKopecks: 3000,
        idempotencyKey: 'key',
      ),
      expect: () => [
        isA<ProductDetailLoading>(),
        isA<ProductDetailLoaded>()
            .having((s) => s.variants.length, 'count', 2)
            .having((s) => s.variants.last.name, 'last name', 'Середній'),
      ],
    );

    blocTest<ProductDetailCubit, ProductDetailState>(
      'loadVariants emits error on failure',
      build: () {
        when(() => repository.fetchVariants(productId: 1)).thenThrow(
          Exception('boom'),
        );
        return ProductDetailCubit(repository);
      },
      act: (cubit) => cubit.loadVariants(productId: 1),
      expect: () => [
        isA<ProductDetailLoading>(),
        isA<ProductDetailError>(),
      ],
    );
  });
}
