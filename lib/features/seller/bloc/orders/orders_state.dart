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

/// NFC payment in progress — terminal launched, waiting for customer.
final class OrdersNfcPaymentPending extends OrdersState {
  const OrdersNfcPaymentPending({required this.products, required this.total});
  final List<Product> products;
  final double total;

  @override
  List<Object> get props => [products, total];
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
