import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/admin/admin_user.dart';
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository.dart';
import 'package:prro/features/admin/tellers/tellers_cubit.dart';

class MockAdminUserRepository extends Mock implements AdminUserRepositoryI {}

void main() {
  late MockAdminUserRepository repository;

  setUp(() {
    repository = MockAdminUserRepository();
  });
  registerFallbackValue(
    const AdminUser(id: 0, name: ''),
  );

  group('TellersCubit', () {
    blocTest<TellersCubit, TellersState>(
      'loadUsers emits loading then loaded for the outlet',
      build: () {
        when(() => repository.fetchUsers(outletId: 1)).thenAnswer(
          (_) async => const [
            AdminUser(id: 1, name: 'Олена', status: DpsStatus.active),
            AdminUser(id: 2, name: 'Іван', status: DpsStatus.registered),
          ],
        );
        return TellersCubit(repository);
      },
      act: (cubit) => cubit.loadUsers(outletId: 1),
      expect: () => [
        isA<TellersLoading>(),
        isA<TellersLoaded>()
            .having((s) => s.users.length, 'users length', 2)
            .having((s) => s.outletId, 'outletId', 1),
      ],
      verify: (cubit) {
        verify(() => repository.fetchUsers(outletId: 1)).called(1);
      },
    );

    blocTest<TellersCubit, TellersState>(
      'loadUsers emits error on failure',
      build: () {
        when(() => repository.fetchUsers(outletId: 1)).thenThrow(
          Exception('boom'),
        );
        return TellersCubit(repository);
      },
      act: (cubit) => cubit.loadUsers(outletId: 1),
      expect: () => [
        isA<TellersLoading>(),
        isA<TellersError>(),
      ],
    );

    blocTest<TellersCubit, TellersState>(
      'selectUser updates selection without refetch',
      build: () => TellersCubit(repository),
      seed: () => const TellersLoaded(
        [AdminUser(id: 1, name: 'Олена'), AdminUser(id: 2, name: 'Іван')],
        1,
      ),
      act: (cubit) => cubit.selectUser(2),
      expect: () => [
        isA<TellersLoaded>().having(
          (s) => s.selectedUserId,
          'selected',
          2,
        ),
      ],
      verify: (_) {
        verifyNever(
          () => repository.fetchUsers(outletId: any(named: 'outletId')),
        );
      },
    );
  });
}
