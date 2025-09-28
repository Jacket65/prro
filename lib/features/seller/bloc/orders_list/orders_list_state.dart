part of 'orders_list_bloc.dart';

sealed class OrdersListState extends Equatable {
  const OrdersListState();

  @override
  List<Object> get props => [];
}

final class OrdersListInitial extends OrdersListState {}

final class OrdersListUpdated extends OrdersListState {
  final List<Product> products;
  final double total;

  const OrdersListUpdated({required this.products, required this.total});

  @override
  List<Object> get props => [products, total];
}
