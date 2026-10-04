part of 'orders_history_cubit.dart';

sealed class OrdersHistoryState {
  const OrdersHistoryState();
}

@Freezed(toJson: false)
class OrdersHistoryInitial extends OrdersHistoryState
    with _$OrdersHistoryInitial {
  const OrdersHistoryInitial();
}

@Freezed(toJson: false)
class OrdersHistoryLoading extends OrdersHistoryState
    with _$OrdersHistoryLoading {
  const OrdersHistoryLoading();
}

@Freezed(toJson: false)
class OrdersHistoryError extends OrdersHistoryState
    with _$OrdersHistoryError {
  const OrdersHistoryError(this.message);

  final String message;
}

@Freezed(toJson: false)
class OrdersHistoryLoaded extends OrdersHistoryState
    with _$OrdersHistoryLoaded {
  const OrdersHistoryLoaded({
    required this.items,
    required this.hasNext,
    required this.page,
    this.sort = 'created_at',
    this.order = 'desc',
    this.isLoadingMore = false,
    this.loadMoreError = false,
  });

  final List<OrderListItem> items;
  final bool hasNext;
  final int page;
  final String sort;
  final String order;
  final bool isLoadingMore;
  final bool loadMoreError;
}
