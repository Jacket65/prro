part of 'orders_history_cubit.dart';

@Freezed(toJson: false)
sealed class OrdersHistoryState with _$OrdersHistoryState {
  const factory OrdersHistoryState.initial() = OrdersHistoryInitial;
  const factory OrdersHistoryState.loading() = OrdersHistoryLoading;
  const factory OrdersHistoryState.error(String message) = OrdersHistoryError;
  const factory OrdersHistoryState.loaded({
    required List<OrderListItem> items,
    required bool hasNext,
    required int page,
    @Default('created_at') String sort,
    @Default('desc') String order,
    @Default(false) bool isLoadingMore,
    @Default(false) bool loadMoreError,
  }) = OrdersHistoryLoaded;
}
