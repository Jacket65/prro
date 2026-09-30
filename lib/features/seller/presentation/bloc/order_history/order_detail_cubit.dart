import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this._repository) : super(const OrderDetailInitial());
  final OrderHistoryRepositoryI _repository;

  Future<void> load(int orderId) async {
    emit(const OrderDetailLoading());
    try {
      final detail = await _repository.getOrder(orderId);
      emit(OrderDetailLoaded(detail));
    } on Object catch (e) {
      emit(OrderDetailError(e.toString()));
    }
  }
}
