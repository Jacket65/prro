part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersUpdated extends OrdersState {
  final List<Product> products;
  final double total;

  const OrdersUpdated({required this.products, required this.total});

  @override
  List<Object> get props => [products, total];
}

/// Payment finished — cart has been cleared, receipt is shown to the cashier.
final class OrdersPaymentSuccess extends OrdersState {
  final OrderReceipt receipt;
  const OrdersPaymentSuccess(this.receipt);
  @override
  List<Object> get props => [receipt];
}

final class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
