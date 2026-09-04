import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:prro/data/repositories/order_history/order_history.dart';
import 'package:prro/features/seller/bloc/order_history/order_detail_cubit.dart';
import 'package:prro/features/seller/bloc/order_history/orders_history_cubit.dart';
import 'package:prro/features/seller/bloc/order_history/shifts_history_cubit.dart';

class MockOrderHistoryRepository extends Mock
    implements OrderHistoryRepositoryI {}

ShiftSummary shift(int id) => ShiftSummary(
  id: id,
  outletId: 1,
  openedBy: 1,
  openedAt: DateTime(2024),
  status: 'closed',
);

OrderListItem order(int id) => OrderListItem(
  orderId: id,
  createdAt: DateTime(2024),
  totalKopecks: 1000,
);

OrderDetail detail(int id) => OrderDetail(
  orderId: id,
  shiftId: 1,
  status: 'paid',
  createdAt: DateTime(2024),
  totalKopecks: 1000,
  items: const [],
  payment: const OrderDetailPayment(
    method: PaymentMethod.cash,
    tenderedKopecks: 1000,
    changeKopecks: 0,
    totalKopecks: 1000,
  ),
);

void main() {
  late MockOrderHistoryRepository repo;

  setUp(() {
    repo = MockOrderHistoryRepository();
  });
  registerFallbackValue(1);
  registerFallbackValue('');

  group('ShiftsHistoryCubit', () {
    blocTest<ShiftsHistoryCubit, ShiftsHistoryState>(
      'loadFirst emits loading then loaded',
      build: () {
        when(() => repo.getShifts()).thenAnswer(
          (_) async => Page<ShiftSummary>(
            items: [shift(1)],
            page: 1,
            hasNext: false,
          ),
        );
        return ShiftsHistoryCubit(repo);
      },
      act: (c) => c.loadFirst(),
      expect: () => [
        isA<ShiftsHistoryLoading>(),
        isA<ShiftsHistoryLoaded>()
            .having((s) => s.items.length, 'items', 1)
            .having((s) => s.hasNext, 'hasNext', false),
      ],
    );

    blocTest<ShiftsHistoryCubit, ShiftsHistoryState>(
      'loadMore appends and stops at hasNext=false',
      build: () {
        when(
          () => repo.getShifts(page: any(named: 'page')),
        ).thenAnswer((inv) async {
          final p = inv.namedArguments[#page] as int? ?? 1;
          if (p == 1) {
            return Page<ShiftSummary>(
              items: [shift(1)],
              page: 1,
              hasNext: true,
              nextPage: 2,
            );
          }
          return Page<ShiftSummary>(
            items: [shift(2)],
            page: 2,
            hasNext: false,
          );
        });
        return ShiftsHistoryCubit(repo);
      },
      act: (c) async {
        await c.loadFirst();
        await c.loadMore();
      },
      expect: () => [
        isA<ShiftsHistoryLoading>(),
        isA<ShiftsHistoryLoaded>().having((s) => s.items.length, 'len', 1),
        isA<ShiftsHistoryLoaded>().having(
          (s) => s.isLoadingMore,
          'loading',
          true,
        ),
        isA<ShiftsHistoryLoaded>()
            .having((s) => s.items.length, 'len', 2)
            .having((s) => s.hasNext, 'hasNext', false),
      ],
    );

    blocTest<ShiftsHistoryCubit, ShiftsHistoryState>(
      'loadMore surfaces error via loadMoreError and keeps hasNext',
      build: () {
        when(
          () => repo.getShifts(page: any(named: 'page')),
        ).thenAnswer((inv) async {
          final p = inv.namedArguments[#page] as int? ?? 1;
          if (p == 1) {
            return Page<ShiftSummary>(
              items: [shift(1)],
              page: 1,
              hasNext: true,
              nextPage: 2,
            );
          }
          throw Exception('boom');
        });
        return ShiftsHistoryCubit(repo);
      },
      act: (c) async {
        await c.loadFirst();
        await c.loadMore();
      },
      expect: () => [
        isA<ShiftsHistoryLoading>(),
        isA<ShiftsHistoryLoaded>().having((s) => s.items.length, 'len', 1),
        isA<ShiftsHistoryLoaded>().having(
          (s) => s.isLoadingMore,
          'loading',
          true,
        ),
        isA<ShiftsHistoryLoaded>()
            .having((s) => s.loadMoreError, 'error', true)
            .having((s) => s.isLoadingMore, 'loading', false)
            .having((s) => s.hasNext, 'hasNext', true),
      ],
    );

    blocTest<ShiftsHistoryCubit, ShiftsHistoryState>(
      'loadMore is a no-op when not loaded',
      build: () => ShiftsHistoryCubit(repo),
      act: (c) => c.loadMore(),
      expect: () => <ShiftsHistoryState>[],
    );
  });

  group('OrdersHistoryCubit', () {
    blocTest<OrdersHistoryCubit, OrdersHistoryState>(
      'loadFirst emits loaded carrying sort/order',
      build: () {
        when(
          () => repo.getShiftOrders(
            1,
            sort: any(named: 'sort'),
            order: any(named: 'order'),
          ),
        ).thenAnswer(
          (_) async => Page<OrderListItem>(
            items: [order(1)],
            page: 1,
            hasNext: false,
          ),
        );
        return OrdersHistoryCubit(repo, 1);
      },
      act: (c) => c.loadFirst(),
      expect: () => [
        isA<OrdersHistoryLoading>(),
        isA<OrdersHistoryLoaded>()
            .having((s) => s.sort, 'sort', 'created_at')
            .having((s) => s.order, 'order', 'desc'),
      ],
    );

    blocTest<OrdersHistoryCubit, OrdersHistoryState>(
      'setSort resets to page 1 with the new sort',
      build: () {
        when(
          () => repo.getShiftOrders(
            1,
            sort: any(named: 'sort'),
            order: any(named: 'order'),
          ),
        ).thenAnswer(
          (_) async => Page<OrderListItem>(
            items: [order(1)],
            page: 1,
            hasNext: false,
          ),
        );
        return OrdersHistoryCubit(repo, 1);
      },
      act: (c) async {
        await c.loadFirst();
        await c.setSort('total_price');
      },
      verify: (_) {
        verify(
          () => repo.getShiftOrders(
            1,
            sort: 'total_price',
            order: any(named: 'order'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<OrdersHistoryLoading>(),
        isA<OrdersHistoryLoaded>(),
        isA<OrdersHistoryLoading>(),
        isA<OrdersHistoryLoaded>().having(
          (s) => s.sort,
          'sort',
          'total_price',
        ),
      ],
    );

    blocTest<OrdersHistoryCubit, OrdersHistoryState>(
      'error path emits OrdersHistoryError',
      build: () {
        when(
          () => repo.getShiftOrders(
            1,
            sort: any(named: 'sort'),
            order: any(named: 'order'),
          ),
        ).thenAnswer((_) async => throw Exception('x'));
        return OrdersHistoryCubit(repo, 1);
      },
      act: (c) => c.loadFirst(),
      expect: () => [
        isA<OrdersHistoryLoading>(),
        isA<OrdersHistoryError>(),
      ],
    );
  });

  group('OrderDetailCubit', () {
    blocTest<OrderDetailCubit, OrderDetailState>(
      'load emits loaded with the detail',
      build: () {
        when(() => repo.getOrder(any())).thenAnswer((_) async => detail(7));
        return OrderDetailCubit(repo);
      },
      act: (c) => c.load(7),
      expect: () => [
        isA<OrderDetailLoading>(),
        isA<OrderDetailLoaded>().having((s) => s.detail.orderId, 'id', 7),
      ],
    );

    blocTest<OrderDetailCubit, OrderDetailState>(
      'error path emits OrderDetailError',
      build: () {
        when(
          () => repo.getOrder(any()),
        ).thenAnswer((_) async => throw Exception('x'));
        return OrderDetailCubit(repo);
      },
      act: (c) => c.load(1),
      expect: () => [
        isA<OrderDetailLoading>(),
        isA<OrderDetailError>(),
      ],
    );
  });
}
