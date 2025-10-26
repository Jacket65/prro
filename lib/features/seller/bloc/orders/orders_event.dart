part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

final class AddProduct extends OrdersEvent {
  final Product product;

  const AddProduct(this.product);

  @override
  List<Object> get props => [product];
}

final class RemoveProduct extends OrdersEvent {
  final Product product;

  const RemoveProduct(this.product);

  @override
  List<Object> get props => [product];
}

final class ClearProducts extends OrdersEvent {
  const ClearProducts();

  @override
  List<Object> get props => [];
}

final class SellProducts extends OrdersEvent {
  final String paymentMethod;
  const SellProducts({required this.paymentMethod});

  @override
  List<Object> get props => [paymentMethod];
}
