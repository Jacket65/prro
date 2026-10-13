part of 'shifts_history_cubit.dart';

@Freezed(toJson: false)
sealed class ShiftsHistoryState with _$ShiftsHistoryState {
  const factory ShiftsHistoryState.initial() = ShiftsHistoryInitial;

  const factory ShiftsHistoryState.loading() = ShiftsHistoryLoading;

  const factory ShiftsHistoryState.error(String message) = ShiftsHistoryError;

  const factory ShiftsHistoryState.loaded({
    required List<ShiftSummary> items,
    required bool hasNext,
    required int page,
    @Default(false) bool isLoadingMore,
    @Default(false) bool loadMoreError,
  }) = ShiftsHistoryLoaded;
}
