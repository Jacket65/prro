import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';

part 'shifts_history_cubit.freezed.dart';
part 'shifts_history_state.dart';

class ShiftsHistoryCubit extends Cubit<ShiftsHistoryState> {
  ShiftsHistoryCubit(this._repository, {this.outletId})
    : super(const ShiftsHistoryState.initial());

  final OrderHistoryRepositoryI _repository;
  final int? outletId;

  int _requestGeneration = 0;
  bool _isLoadingFirst = false;
  bool _isLoadingMore = false;

  Future<void> loadFirst() async {
    if (_isLoadingFirst) return;

    _isLoadingFirst = true;
    _isLoadingMore = false;
    final generation = ++_requestGeneration;

    emit(const ShiftsHistoryState.loading());

    try {
      final page = await _repository.getShifts(outletId: outletId);

      if (isClosed || generation != _requestGeneration) return;

      emit(
        ShiftsHistoryState.loaded(
          items: page.items,
          hasNext: page.hasNext,
          page: page.page,
        ),
      );
    } on Object catch (e) {
      if (isClosed || generation != _requestGeneration) return;

      emit(ShiftsHistoryState.error(e.toString()));
    } finally {
      if (generation == _requestGeneration) {
        _isLoadingFirst = false;
      }
    }
  }

  Future<void> loadMore() async {
    final current = state;

    if (current is! ShiftsHistoryLoaded) return;
    if (!current.hasNext || _isLoadingFirst || _isLoadingMore) return;

    _isLoadingMore = true;
    final generation = _requestGeneration;

    emit(current.copyWith(isLoadingMore: true, loadMoreError: false));

    try {
      final next = await _repository.getShifts(
        outletId: outletId,
        page: current.page + 1,
      );

      if (isClosed || generation != _requestGeneration) return;

      emit(
        current.copyWith(
          items: [...current.items, ...next.items],
          hasNext: next.hasNext,
          page: next.page,
          isLoadingMore: false,
          loadMoreError: false,
        ),
      );
    } on Object catch (_) {
      if (isClosed || generation != _requestGeneration) return;

      final latest = state;
      if (latest is ShiftsHistoryLoaded) {
        emit(latest.copyWith(isLoadingMore: false, loadMoreError: true));
      }
    } finally {
      _isLoadingMore = false;
    }
  }
}
