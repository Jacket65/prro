part of 'shifts_history_cubit.dart';

sealed class ShiftsHistoryState extends Equatable {
  const ShiftsHistoryState();

  @override
  List<Object?> get props => [];
}

final class ShiftsHistoryInitial extends ShiftsHistoryState {
  const ShiftsHistoryInitial();
}

final class ShiftsHistoryLoading extends ShiftsHistoryState {
  const ShiftsHistoryLoading();
}

final class ShiftsHistoryError extends ShiftsHistoryState {
  const ShiftsHistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class ShiftsHistoryLoaded extends ShiftsHistoryState {
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

  ShiftsHistoryLoaded copyWith({
    List<ShiftSummary>? items,
    bool? hasNext,
    int? page,
    bool? isLoadingMore,
    bool? loadMoreError,
  }) =>
      ShiftsHistoryLoaded(
        items: items ?? this.items,
        hasNext: hasNext ?? this.hasNext,
        page: page ?? this.page,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError: loadMoreError ?? this.loadMoreError,
      );

  @override
  List<Object?> get props => [
    items,
    hasNext,
    page,
    isLoadingMore,
    loadMoreError,
  ];
}
