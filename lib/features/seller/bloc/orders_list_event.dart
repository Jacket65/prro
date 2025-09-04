part of 'orders_list_bloc.dart';

sealed class OrdersListEvent extends Equatable {
  const OrdersListEvent();

  @override
  List<Object> get props => [];
}

final class AddProduct extends OrdersListEvent {
  final Product product;

  const AddProduct(this.product);

  @override
  List<Object> get props => [product];
}

final class RemoveProduct extends OrdersListEvent {
  final Product product;

  const RemoveProduct(this.product);

  @override
  List<Object> get props => [product];
}
