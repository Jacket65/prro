part of 'orders_list_bloc.dart';

sealed class OrdersListState extends Equatable {
  const OrdersListState();

  @override
  List<Object> get props => [];
}

final class OrdersListInitial extends OrdersListState {}

final class OrdersListUpdated extends OrdersListState {
  final List<Product> products;

  const OrdersListUpdated(this.products);
  @override
  List<Object> get props => [products];
}
