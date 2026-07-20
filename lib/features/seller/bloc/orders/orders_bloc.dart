import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(this._ordersRepository) : super(OrdersInitial()) {
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
    on<DeleteProductLine>(_onDeleteProductLine);
    on<ClearProducts>(_onClearProducts);
    on<PayOrder>(_onPayOrder);
    on<AcknowledgePayment>(_onAcknowledgePayment);
    on<UpdateOptions>(_onUpdateOptions);
  }
  final OrdersRepositoryI _ordersRepository;

  void _onUpdateOptions(UpdateOptions event, Emitter<OrdersState> emit) {
    _ordersRepository.updateOptions(
      event.lineId,
      event.options,
      bean: event.bean,
      quantity: event.quantity,
    );
    emit(_buildUpdatedState());
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

  void _onDeleteProductLine(
    DeleteProductLine event,
    Emitter<OrdersState> emit,
  ) {
    _ordersRepository.deleteProductLine(event.product);
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

  Future<void> _onPayOrder(PayOrder event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading(products: _ordersRepository.products));
    try {
      final receipt = await _ordersRepository.placeOrder(
        method: event.method,
        tenderedKopecks: event.tenderedKopecks,
        idempotencyKey: event.idempotencyKey,
      );
      _ordersRepository.clearProducts();
      emit(OrdersPaymentSuccess(receipt));
    } on ApiException catch (e) {
      emit(
        OrdersError(
          message: e.message,
          products: _ordersRepository.products,
          total: _ordersRepository.totalPrice,
        ),
      );
    } on Object catch (e) {
      emit(
        OrdersError(
          message: 'Не вдалося оплатити: $e',
          products: _ordersRepository.products,
          total: _ordersRepository.totalPrice,
        ),
      );
    }
  }

  void _onAcknowledgePayment(
    AcknowledgePayment event,
    Emitter<OrdersState> emit,
  ) {
    if (_ordersRepository.products.isEmpty) {
      emit(OrdersInitial());
    } else {
      emit(_buildUpdatedState());
    }
  }

  OrdersUpdated _buildUpdatedState() {
    return OrdersUpdated(
      products: _ordersRepository.products,
      total: _ordersRepository.totalPrice,
    );
  }
}
