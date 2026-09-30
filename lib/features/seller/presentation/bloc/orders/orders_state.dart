part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {
  const OrdersLoading({this.products = const []});
  final List<Product> products;

  @override
  List<Object> get props => [products];
}

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

/// A payment is being processed for the current cart (any method). The dialog
/// renders a method-specific view from [method] + [total].
final class OrdersPaymentProcessing extends OrdersState {
  const OrdersPaymentProcessing({required this.method, required this.total});
  final PaymentMethod method;
  final double total;

  @override
  List<Object> get props => [method, total];
}

final class OrdersError extends OrdersState {
  const OrdersError({
    required this.message,
    required this.products,
    required this.total,
  });
  final String message;
  final List<Product> products;
  final double total;

  @override
  List<Object> get props => [message];
}
