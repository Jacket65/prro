import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';
import 'package:prro/features/seller/bloc/orders/payment/pay_order_request.dart';
import 'package:prro/features/seller/bloc/orders/payment/pay_order_use_case.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({
    required this._ordersRepository,
    required this._payOrder,
  }) : super(OrdersInitial()) {
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
    on<DeleteProductLine>(_onDeleteProductLine);
    on<ClearProducts>(_onClearProducts);
    on<PayOrder>(_onPayOrder);
    on<CancelPayment>(_onCancelPayment);
    on<AcknowledgePayment>(_onAcknowledgePayment);
    on<UpdateOptions>(_onUpdateOptions);
  }
  final OrdersRepositoryI _ordersRepository;
  final PayOrderUseCase _payOrder;

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

  /// Id of the payment attempt currently being processed, or `null` when idle.
  ///
  /// Used to (a) serialize payments — a second [PayOrder] while one is in
  /// flight is dropped rather than starting a concurrent charge, and (b) reject
  /// a stale async result: only the outcome that matches the active
  /// `paymentId` is allowed to change state. Assigning it synchronously before
  /// the first `await` makes the guard race-free on the single Dart isolate.
  String? _currentPaymentId;

  Future<void> _onPayOrder(PayOrder event, Emitter<OrdersState> emit) async {
    // Serialize: ignore a second payment attempt while one is active. This is
    // stronger than the `state is OrdersPaymentProcessing` check and prevents
    // any concurrent charge even if two events arrive back-to-back.
    if (_currentPaymentId != null) {
      return;
    }
    final paymentId = uuidV4();
    _currentPaymentId = paymentId;

    emit(
      OrdersPaymentProcessing(
        method: event.method,
        total: _ordersRepository.totalPrice,
      ),
    );
    try {
      final receipt = await _payOrder(
        PayOrderRequest(
          method: event.method,
          tenderedKopecks: event.tenderedKopecks,
          idempotencyKey: event.idempotencyKey,
        ),
      );
      // Stale guard: a newer payment (or a cancelled/closed bloc) may have
      // superseded this attempt by the time the future resolves.
      if (_currentPaymentId != paymentId) return;
      _ordersRepository.clearProducts();
      emit(OrdersPaymentSuccess(receipt));
    } on PaymentCancelledException {
      if (_currentPaymentId != paymentId) return;
      // Cancellation returns to the editable form without clearing the order.
      emit(_buildUpdatedState());
    } on PaymentException catch (e) {
      if (_currentPaymentId != paymentId) return;
      emit(
        OrdersError(
          message: e.message,
          products: _ordersRepository.products,
          total: _ordersRepository.totalPrice,
        ),
      );
    } on ApiException catch (e) {
      // Defense in depth: most failures are already translated to
      // PaymentException by the payment boundary, but a repository exception
      // that escaped is still surfaced safely.
      if (_currentPaymentId != paymentId) return;
      emit(
        OrdersError(
          message: e.message,
          products: _ordersRepository.products,
          total: _ordersRepository.totalPrice,
        ),
      );
    } on Object {
      if (_currentPaymentId != paymentId) return;
      emit(
        OrdersError(
          message: 'Не вдалося оплатити. Спробуйте ще раз.',
          products: _ordersRepository.products,
          total: _ordersRepository.totalPrice,
        ),
      );
    } finally {
      // Only reset our own attempt so a newer, in-flight payment is never
      // clobbered.
      if (_currentPaymentId == paymentId) {
        _currentPaymentId = null;
      }
    }
  }

  Future<void> _onCancelPayment(
    CancelPayment _,
    Emitter<OrdersState> _,
  ) async => _payOrder.cancel();

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
