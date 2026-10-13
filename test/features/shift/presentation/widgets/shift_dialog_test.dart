import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// `material_ui` is a material-library fork: the dialog builds its tree from
// it, so the test must host the dialog with its `MaterialApp` too, or the
// localizations assert inside its `showDialog` fires.
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/features/shift/domain/entities/shift.dart';
import 'package:prro/features/shift/domain/repositories/shift_repository_i.dart';
import 'package:prro/features/shift/presentation/cubit/shift_cubit.dart';
import 'package:prro/features/shift/presentation/widgets/shift_dialog.dart';

class MockShiftRepository extends Mock implements ShiftRepositoryI {}

/// One widget, two ends of the shift. P2-3b merged `OpenShiftDialog` and
/// `CloseShiftDialog` into [ShiftDialog] with a [ShiftDialogMode]; each mode
/// keeps its own wording, its own cubit call and its own success signal —
/// including the M3 fix that a close is only reported for
/// `ShiftNone(closedByUser)`.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockShiftRepository repository;
  late ShiftCubit cubit;

  /// Pumps a host that opens the dialog in [mode] and records its result, the
  /// same way the seller screen does (`_closeShift`, `_OpenShiftGate`).
  Future<void> pumpHost(
    WidgetTester tester,
    ShiftDialogMode mode, {
    required ValueSetter<Object?> onResult,
    required ShiftResponse? shift,
    required Object? closeError,
    required Object? openError,
  }) async {
    when(repository.currentShift).thenAnswer((_) async => shift);
    when(
      () => repository.closeShift(
        cashEnd: any(named: 'cashEnd'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async {
      if (closeError != null) throw Exception('server down');
    });
    when(
      () => repository.openShift(
        idempotencyKey: any(named: 'idempotencyKey'),
        cashStart: any(named: 'cashStart'),
      ),
    ).thenAnswer((_) async {
      if (openError != null) throw Exception('server down');
      return shift ?? _shift();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    onResult(await ShiftDialog.show(context, mode));
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  setUp(() {
    repository = MockShiftRepository();
    cubit = ShiftCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('close mode', () {
    testWidgets('pops true only for a real close (closedByUser)', (
      tester,
    ) async {
      Object? result;

      await pumpHost(
        tester,
        ShiftDialogMode.close,
        onResult: (r) => result = r,
        shift: _shift(),
        closeError: null,
        openError: null,
      );

      expect(find.text('Готівка в касі на момент закриття:'), findsOne);
      final closeButton = find.widgetWithText(FilledButton, 'Закрити зміну');
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(result, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('a session reset while the dialog is open does not pop', (
      tester,
    ) async {
      Object? result;

      await pumpHost(
        tester,
        ShiftDialogMode.close,
        onResult: (r) => result = r,
        shift: _shift(),
        closeError: null,
        openError: null,
      );

      // The app-level session teardown fires while the dialog is open (M3: it
      // used to be read as a successful close).
      cubit.reset();
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Скасувати'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('a failed close keeps the dialog open for a retry', (
      tester,
    ) async {
      Object? result;

      await pumpHost(
        tester,
        ShiftDialogMode.close,
        onResult: (r) => result = r,
        shift: _shift(),
        closeError: Exception('server down'),
        openError: null,
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Закрити зміну'));
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('server down'), findsOneWidget);
    });
  });

  group('open mode', () {
    testWidgets('pops true once the backend confirms the open', (tester) async {
      Object? result;

      await pumpHost(
        tester,
        ShiftDialogMode.open,
        onResult: (r) => result = r,
        shift: null,
        closeError: null,
        openError: null,
      );

      expect(find.text('Готівка в касі на початок зміни:'), findsOne);
      await tester.tap(find.widgetWithText(FilledButton, 'Відкрити зміну'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('a failed open keeps the dialog open', (tester) async {
      Object? result;

      await pumpHost(
        tester,
        ShiftDialogMode.open,
        onResult: (r) => result = r,
        shift: null,
        closeError: null,
        openError: Exception('server down'),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Відкрити зміну'));
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('server down'), findsOneWidget);
    });
  });
}

ShiftResponse _shift({String status = 'open'}) => ShiftResponse(
  id: 5,
  outletId: 7,
  openedBy: 3,
  openedAt: '2026-01-01T08:00:00Z',
  cashStart: '0.00',
  status: status,
);
