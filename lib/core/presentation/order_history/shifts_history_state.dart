part of 'shifts_history_cubit.dart';

sealed class ShiftsHistoryState {
  const ShiftsHistoryState();
}

@Freezed(toJson: false)
class ShiftsHistoryInitial extends ShiftsHistoryState
    with _$ShiftsHistoryInitial {
  const ShiftsHistoryInitial();
}

@Freezed(toJson: false)
class ShiftsHistoryLoading extends ShiftsHistoryState
    with _$ShiftsHistoryLoading {
  const ShiftsHistoryLoading();
}

@Freezed(toJson: false)
class ShiftsHistoryError extends ShiftsHistoryState
    with _$ShiftsHistoryError {
  const ShiftsHistoryError(this.message);

  final String message;
}

@Freezed(toJson: false)
class ShiftsHistoryLoaded extends ShiftsHistoryState
    with _$ShiftsHistoryLoaded {
  const ShiftsHistoryLoaded({
    required this.items,
    required this.hasNext,
    required this.page,
    this.isLoadingMore = false,
    this.loadMoreError = false,
  });

  final List<ShiftSummary> items;
  final bool hasNext;
  final int page;
  final bool isLoadingMore;
  final bool loadMoreError;
}
