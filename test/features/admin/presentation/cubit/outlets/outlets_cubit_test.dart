import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/features/admin/data/models/retail_outlet.dart';
import 'package:prro/features/admin/domain/repositories/admin_outlet_repository_i.dart';
import 'package:prro/features/admin/presentation/cubit/outlets/outlets_cubit.dart';

class MockAdminOutletRepository extends Mock
    implements AdminOutletRepositoryI {}

void main() {
  late MockAdminOutletRepository repository;

  setUp(() {
    repository = MockAdminOutletRepository();
  });
  registerFallbackValue(const RetailOutlet(id: 0, name: ''));

  group('OutletsCubit', () {
    blocTest<OutletsCubit, OutletsState>(
      'loadOutlets emits loading then loaded with first outlet selected',
      build: () {
        when(() => repository.fetchOutlets()).thenAnswer(
          (_) async => const [
            RetailOutlet(id: 1, name: 'Центр', city: 'Київ'),
            RetailOutlet(id: 2, name: 'Лівий берег', city: 'Київ'),
          ],
        );
        return OutletsCubit(repository);
      },
      act: (cubit) => cubit.loadOutlets(),
      expect: () => [
        isA<OutletsLoading>(),
        isA<OutletsLoaded>()
            .having((s) => s.outlets.length, 'outlets length', 2)
            .having((s) => s.selectedOutletId, 'selected', 1),
      ],
      verify: (cubit) {
        verify(() => repository.fetchOutlets()).called(1);
      },
    );

    blocTest<OutletsCubit, OutletsState>(
      'loadOutlets emits error on failure',
      build: () {
        when(() => repository.fetchOutlets()).thenThrow(Exception('boom'));
        return OutletsCubit(repository);
      },
      act: (cubit) => cubit.loadOutlets(),
      expect: () => [isA<OutletsLoading>(), isA<OutletsError>()],
    );

    blocTest<OutletsCubit, OutletsState>(
      'selectOutlet updates selection without refetch',
      build: () {
        when(() => repository.fetchOutlets()).thenAnswer(
          (_) async => const [
            RetailOutlet(id: 1, name: 'Центр'),
            RetailOutlet(id: 2, name: 'Лівий берег'),
          ],
        );
        return OutletsCubit(repository);
      },
      seed: () => const OutletsLoaded([
        RetailOutlet(id: 1, name: 'Центр'),
        RetailOutlet(id: 2, name: 'Лівий берег'),
      ], selectedOutletId: 1),
      act: (cubit) => cubit.selectOutlet(2),
      expect: () => [
        isA<OutletsLoaded>().having((s) => s.selectedOutletId, 'selected', 2),
      ],
      verify: (_) {
        verifyNever(() => repository.fetchOutlets());
      },
    );
  });
}
