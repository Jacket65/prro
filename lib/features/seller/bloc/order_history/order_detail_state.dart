part of 'order_detail_cubit.dart';

sealed class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object?> get props => [];
}

final class OrderDetailInitial extends OrderDetailState {
  const OrderDetailInitial();
}

final class OrderDetailLoading extends OrderDetailState {
  const OrderDetailLoading();
}

final class OrderDetailError extends OrderDetailState {
  const OrderDetailError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class OrderDetailLoaded extends OrderDetailState {
  const OrderDetailLoaded(this.detail);
  final OrderDetail detail;

  @override
  List<Object?> get props => [detail];
}
