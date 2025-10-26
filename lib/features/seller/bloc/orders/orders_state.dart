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

final class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
