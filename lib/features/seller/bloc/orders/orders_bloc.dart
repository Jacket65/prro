import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepositoryI _ordersRepository;

  OrdersBloc(this._ordersRepository) : super(OrdersInitial()) {
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
    on<ClearProducts>(_onClearProducts);
    on<SellProducts>(_onSellProducts);
  }

  void _onAddProduct(AddProduct event, Emitter<OrdersState> emit) {
    _ordersRepository.addProduct(event.product);
    emit(_buildUpdatedState());
  }

  void _onRemoveProduct(RemoveProduct event, Emitter<OrdersState> emit) {
    _ordersRepository.removeProduct(event.product);
    if (_ordersRepository.products.isEmpty) {
      emit(OrdersInitial());
    } else {
      emit(_buildUpdatedState());
    }
  }

  void _onClearProducts(ClearProducts event, Emitter<OrdersState> emit) {
    _ordersRepository.clearProducts();
    emit(OrdersInitial());
  }

  Future<void> _onSellProducts(
    SellProducts event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      await _ordersRepository.sell(event.paymentMethod);
      _ordersRepository.clearProducts();
      emit(OrdersInitial());
    } catch (e) {
      emit(OrdersError('Failed to sell products: $e'));
    }
  }

  OrdersUpdated _buildUpdatedState() {
    return OrdersUpdated(
      products: _ordersRepository.products,
      total: _ordersRepository.totalPrice,
    );
  }
}
