import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:prro/data/repositories/order_history/order_history.dart';

part 'orders_history_state.dart';

class OrdersHistoryCubit extends Cubit<OrdersHistoryState> {
  OrdersHistoryCubit(this._repository, this.shiftId)
    : super(const OrdersHistoryInitial());
  final OrderHistoryRepositoryI _repository;
  final int shiftId;

  String _sort = 'created_at';
  String _order = 'desc';

  String get sort => _sort;
  String get order => _order;

  Future<void> loadFirst() async {
    emit(const OrdersHistoryLoading());
    try {
      final page = await _repository.getShiftOrders(
        shiftId,
        sort: _sort,
        order: _order,
      );
      emit(
        OrdersHistoryLoaded(
          items: page.items,
          hasNext: page.hasNext,
          page: page.page,
          sort: _sort,
          order: _order,
        ),
      );
    } on Object catch (e) {
      emit(OrdersHistoryError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! OrdersHistoryLoaded) return;
    if (!current.hasNext || current.isLoadingMore) return;
    emit(current.copyWith(isLoadingMore: true, loadMoreError: false));
    try {
      final next = await _repository.getShiftOrders(
        shiftId,
        page: current.page + 1,
        sort: _sort,
        order: _order,
      );
      emit(
        OrdersHistoryLoaded(
          items: [...current.items, ...next.items],
          hasNext: next.hasNext,
          page: next.page,
          sort: _sort,
          order: _order,
        ),
      );
    } on Object catch (_) {
      emit(current.copyWith(isLoadingMore: false, loadMoreError: true));
    }
  }

  Future<void> setSort(String sort) async {
    if (sort == _sort) return;
    _sort = sort;
    await loadFirst();
  }

  Future<void> setOrder(String order) async {
    if (order == _order) return;
    _order = order;
    await loadFirst();
  }
}
