part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersUpdated extends OrdersState {

  const OrdersUpdated({required this.products, required this.total});
  final List<Product> products;
  final double total;

  @override
  List<Object> get props => [products, total];
}

/// Payment finished — cart has been cleared, receipt is shown to the cashier.
final class OrdersPaymentSuccess extends OrdersState {
  const OrdersPaymentSuccess(this.receipt);
  final OrderReceipt receipt;
  @override
  List<Object> get props => [receipt];
}

final class OrdersError extends OrdersState {
  const OrdersError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
