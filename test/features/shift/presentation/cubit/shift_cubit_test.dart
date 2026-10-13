import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/features/shift/domain/entities/shift.dart';
import 'package:prro/features/shift/domain/repositories/shift_repository_i.dart';
import 'package:prro/features/shift/presentation/cubit/shift_cubit.dart';

class MockShiftRepository extends Mock implements ShiftRepositoryI {}

ShiftResponse _shift({String status = 'open'}) => ShiftResponse(
  id: 5,
  outletId: 7,
  openedBy: 3,
  openedAt: '2026-01-01T08:00:00Z',
  cashStart: '0.00',
  status: status,
);

/// Pins *why* [ShiftNone] was emitted: the close dialog pops only for
/// `closedByUser` (M3 — a session reset while the dialog is open used to
/// report a close that never happened), and the seller cart resets for every
/// cause, which is why the cause travels with the state.
void main() {
  late MockShiftRepository repository;
  late ShiftCubit cubit;

  setUp(() {
    repository = MockShiftRepository();
    cubit = ShiftCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('loadCurrent', () {
    test('a 404 shift state carries noOpenShift', () async {
      when(repository.currentShift).thenAnswer((_) async => null);

      await cubit.loadCurrent();

      expect(cubit.state, isA<ShiftNone>());
      expect((cubit.state as ShiftNone).cause, ShiftNoneCause.noOpenShift);
    });

    test('an open shift becomes ShiftOpen', () async {
      when(repository.currentShift).thenAnswer((_) async => _shift());

      await cubit.loadCurrent();

      expect(cubit.state, isA<ShiftOpen>());
    });
  });

  group('closeShift', () {
    test('a confirmed close carries closedByUser', () async {
      when(
        () => repository.closeShift(
          cashEnd: any(named: 'cashEnd'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async {});

      await cubit.closeShift(cashEnd: '125.00', idempotencyKey: 'k');

      expect(cubit.state, const ShiftNone(cause: ShiftNoneCause.closedByUser));
    });

    test('a failed close is an error, not ShiftNone', () async {
      // The dialog must not pop "true" for a close that never happened.
      when(
        () => repository.closeShift(
          cashEnd: any(named: 'cashEnd'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenThrow(Exception('boom'));

      await cubit.closeShift(cashEnd: '125.00', idempotencyKey: 'k');

      expect(cubit.state, isA<ShiftError>());
    });
  });

  group('reset', () {
    test('a session reset carries sessionReset', () async {
      cubit.reset();

      expect(cubit.state, const ShiftNone(cause: ShiftNoneCause.sessionReset));
    });
  });
}
