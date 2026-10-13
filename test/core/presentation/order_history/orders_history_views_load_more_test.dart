import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// `material_ui` is a material-library fork: the views build their trees from
// it, so the tests host with it (and only it) for material widgets.
import 'package:material_ui/material_ui.dart' hide Page;
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/presentation/order_history/orders_history_cubit.dart';
import 'package:prro/core/presentation/order_history/orders_history_view.dart';
import 'package:prro/core/presentation/order_history/shifts_history_cubit.dart';
import 'package:prro/core/presentation/order_history/shifts_history_view.dart';
import 'package:prro/core/theme/theme.dart';

class MockOrderHistoryRepository extends Mock
    implements OrderHistoryRepositoryI {}

/// Counts [loadMore] invocations. The cubit ignores a loadMore while one is in
/// flight, so the guard that matters is in the view: only a counted call makes
/// the re-arm observable.
class _CountingShiftsCubit extends ShiftsHistoryCubit {
  // The base's field-formal parameter is private (`_repository`), so a super
  // parameter cannot share its name.
  // ignore: matching_super_parameters
  _CountingShiftsCubit(super.repository);

  int loadMoreCalls = 0;

  @override
  Future<void> loadMore() {
    loadMoreCalls++;
    return super.loadMore();
  }
}

class _CountingOrdersCubit extends OrdersHistoryCubit {
  // The base's field-formal parameter is private (`_repository`), so a super
  // parameter cannot share its name.
  // ignore: matching_super_parameters
  _CountingOrdersCubit(super.repository, super.shiftId);

  int loadMoreCalls = 0;

  @override
  Future<void> loadMore() {
    loadMoreCalls++;
    return super.loadMore();
  }
}

void _noop(int _) {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockOrderHistoryRepository repository;

  setUp(() {
    repository = MockOrderHistoryRepository();
  });

  Page<ShiftSummary> firstShiftPage() => Page<ShiftSummary>.fromJson(const {
    'items': [
      {'id': 5, 'opened_at': '2026-01-02T09:00:00Z', 'status': 'open'},
    ],
    'page': 1,
    'has_next': true,
  }, ShiftSummary.fromJson);

  Page<OrderListItem> firstOrdersPage() => Page<OrderListItem>.fromJson(const {
    'items': [
      {
        'order_id': 11,
        'created_at': '2026-01-02T10:00:00Z',
        'total_price': '45.00',
      },
    ],
    'page': 1,
    'has_next': true,
  }, OrderListItem.fromJson);

  /// First page with something to load; page 2 never completes, so the
  /// trailing row stays in its loading state across every later frame.
  void stubPagedShifts(Completer<Page<ShiftSummary>> pending) {
    // Two invocation shapes: loadFirst passes no page, loadMore does — mocktail
    // matches named arguments exactly, so each gets its own stub.
    when(
      () => repository.getShifts(outletId: any(named: 'outletId')),
    ).thenAnswer((_) async => firstShiftPage());
    when(
      () => repository.getShifts(
        outletId: any(named: 'outletId'),
        page: any(named: 'page'),
      ),
    ).thenAnswer((invocation) {
      final page = invocation.namedArguments[#page] as int?;
      if (page != null && page > 1) return pending.future;
      return Future.value(firstShiftPage());
    });
  }

  void stubPagedOrders(Completer<Page<OrderListItem>> pending) {
    when(
      () => repository.getShiftOrders(
        any<int>(),
        sort: any(named: 'sort'),
        order: any(named: 'order'),
      ),
    ).thenAnswer((_) async => firstOrdersPage());
    when(
      () => repository.getShiftOrders(
        any<int>(),
        page: any(named: 'page'),
        sort: any(named: 'sort'),
        order: any(named: 'order'),
      ),
    ).thenAnswer((invocation) {
      final page = invocation.namedArguments[#page] as int?;
      if (page != null && page > 1) return pending.future;
      return Future.value(firstOrdersPage());
    });
  }

  /// Pumps several frames: the trailing row schedules loadMore on the first
  /// one, and every later frame would re-arm it without the view's guard.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  group('loadMore re-arm (L17)', () {
    testWidgets('the shifts view schedules exactly one loadMore while a page '
        'is in flight', (tester) async {
      final pending = Completer<Page<ShiftSummary>>();
      stubPagedShifts(pending);
      final cubit = _CountingShiftsCubit(repository);

      await tester.pumpWidget(
        MaterialApp(
          // The tiles read the app's status colors from the theme.
          theme: lightTheme,
          home: BlocProvider<ShiftsHistoryCubit>.value(
            value: cubit,
            child: const Scaffold(body: ShiftsHistoryView(onOpenOrders: _noop)),
          ),
        ),
      );
      await cubit.loadFirst();
      await pumpFrames(tester);

      // One scheduled loadMore. The trailing row rebuilt while the request
      // was in flight; without the guard it would keep re-scheduling.
      expect(cubit.loadMoreCalls, 1);

      pending.complete(
        Page<ShiftSummary>.fromJson(const {
          'items': [
            {'id': 4, 'opened_at': '2026-01-02T08:00:00Z', 'status': 'closed'},
          ],
          'page': 2,
          'has_next': false,
        }, ShiftSummary.fromJson),
      );
      await tester.pumpAndSettle();
      expect(cubit.loadMoreCalls, 1);
      await cubit.close();
    });

    testWidgets('the orders view schedules exactly one loadMore while a page '
        'is in flight', (tester) async {
      final pending = Completer<Page<OrderListItem>>();
      stubPagedOrders(pending);
      final cubit = _CountingOrdersCubit(repository, 5);

      await tester.pumpWidget(
        MaterialApp(
          // The order tiles read the app's status colors from the theme.
          theme: lightTheme,
          home: BlocProvider<OrdersHistoryCubit>.value(
            value: cubit,
            child: const Scaffold(body: OrdersHistoryView(onOpenOrder: _noop)),
          ),
        ),
      );
      await cubit.loadFirst();
      await pumpFrames(tester);

      expect(cubit.loadMoreCalls, 1);

      pending.complete(
        Page<OrderListItem>.fromJson(const {
          'items': [
            {
              'order_id': 10,
              'created_at': '2026-01-02T09:00:00Z',
              'total_price': '45.00',
            },
          ],
          'page': 2,
          'has_next': false,
        }, OrderListItem.fromJson),
      );
      await tester.pumpAndSettle();
      expect(cubit.loadMoreCalls, 1);
      await cubit.close();
    });
  });
}
