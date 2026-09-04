part of 'orders_history_cubit.dart';

sealed class OrdersHistoryState extends Equatable {
  const OrdersHistoryState();

  @override
  List<Object?> get props => [];
}

final class OrdersHistoryInitial extends OrdersHistoryState {
  const OrdersHistoryInitial();
}

final class OrdersHistoryLoading extends OrdersHistoryState {
  const OrdersHistoryLoading();
}

final class OrdersHistoryError extends OrdersHistoryState {
  const OrdersHistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class OrdersHistoryLoaded extends OrdersHistoryState {
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

  OrdersHistoryLoaded copyWith({
    List<OrderListItem>? items,
    bool? hasNext,
    int? page,
    String? sort,
    String? order,
    bool? isLoadingMore,
    bool? loadMoreError,
  }) => OrdersHistoryLoaded(
    items: items ?? this.items,
    hasNext: hasNext ?? this.hasNext,
    page: page ?? this.page,
    sort: sort ?? this.sort,
    order: order ?? this.order,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
  );

  @override
  List<Object?> get props => [
    items,
    hasNext,
    page,
    sort,
    order,
    isLoadingMore,
    loadMoreError,
  ];
}
