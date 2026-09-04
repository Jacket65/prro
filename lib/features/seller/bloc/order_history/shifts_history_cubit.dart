import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:prro/data/repositories/order_history/order_history.dart';

part 'shifts_history_state.dart';

class ShiftsHistoryCubit extends Cubit<ShiftsHistoryState> {
  ShiftsHistoryCubit(this._repository) : super(const ShiftsHistoryInitial());
  final OrderHistoryRepositoryI _repository;

  Future<void> loadFirst() async {
    emit(const ShiftsHistoryLoading());
    try {
      final page = await _repository.getShifts();
      emit(
        ShiftsHistoryLoaded(
          items: page.items,
          hasNext: page.hasNext,
          page: page.page,
        ),
      );
    } on Object catch (e) {
      emit(ShiftsHistoryError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ShiftsHistoryLoaded) return;
    if (!current.hasNext || current.isLoadingMore) return;
    emit(current.copyWith(isLoadingMore: true, loadMoreError: false));
    try {
      final next = await _repository.getShifts(page: current.page + 1);
      emit(
        ShiftsHistoryLoaded(
          items: [...current.items, ...next.items],
          hasNext: next.hasNext,
          page: next.page,
        ),
      );
    } on Object catch (_) {
      emit(current.copyWith(isLoadingMore: false, loadMoreError: true));
    }
  }
}
