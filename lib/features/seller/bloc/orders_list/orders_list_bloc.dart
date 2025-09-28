import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/seller_item.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';

part 'orders_list_event.dart';
part 'orders_list_state.dart';

class OrdersListBloc extends Bloc<OrdersListEvent, OrdersListState> {
  final OrdersRepositoryI _ordersRepository;

  OrdersListBloc(this._ordersRepository) : super(OrdersListInitial()) {
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
    on<ClearProducts>(_onClearProducts);
  }

  FutureOr<void> _onAddProduct(
    AddProduct event,
    Emitter<OrdersListState> emit,
  ) {
    _ordersRepository.addProduct(event.product);
    emit(
      OrdersListUpdated(
        products: _ordersRepository.products,
        total: _ordersRepository.totalPrice,
      ),
    );
  }

  FutureOr<void> _onRemoveProduct(
    RemoveProduct event,
    Emitter<OrdersListState> emit,
  ) {
    _ordersRepository.removeProduct(event.product);
    final updatedList = _ordersRepository.products;
    if (updatedList.isEmpty) {
      emit(OrdersListInitial());
    } else {
      emit(
        OrdersListUpdated(
          products: updatedList,
          total: _ordersRepository.totalPrice,
        ),
      );
    }
  }

  FutureOr<void> _onClearProducts(
    ClearProducts event,
    Emitter<OrdersListState> emit,
  ) {
    _ordersRepository.clearProducts();
    emit(OrdersListInitial());
  }
}
