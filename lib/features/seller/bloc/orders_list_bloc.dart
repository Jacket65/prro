import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/seller_item.dart';

part 'orders_list_event.dart';
part 'orders_list_state.dart';

class OrdersListBloc extends Bloc<OrdersListEvent, OrdersListState> {
  final List<Product> _products = [];

  OrdersListBloc() : super(OrdersListInitial()) {
    on<AddProduct>((event, emit) {
      final index = _products.indexWhere((p) => p.id == event.product.id);

      if (index != -1) {
        final updated = _products[index].copyWith(
          quantity: _products[index].quantity + 1,
        );
        _products[index] = updated;
      } else {
        _products.add(event.product);
      }

      emit(OrdersListUpdated(List.from(_products)));
    });

    on<RemoveProduct>((event, emit) {
      final index = _products.indexWhere((p) => p.id == event.product.id);

      if (index != -1) {
        final current = _products[index];
        if (current.quantity > 1) {
          _products[index] = current.copyWith(quantity: current.quantity - 1);
        } else {
          _products.removeAt(index);
        }
        emit(OrdersListUpdated(List.from(_products)));
      } else {
        emit(OrdersListInitial());
      }
    });
  }
}
