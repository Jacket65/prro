part of 'order_detail_cubit.dart';

sealed class OrderDetailState {
  const OrderDetailState();
}

@Freezed(toJson: false)
class OrderDetailInitial extends OrderDetailState
    with _$OrderDetailInitial {
  const OrderDetailInitial();
}

@Freezed(toJson: false)
class OrderDetailLoading extends OrderDetailState with _$OrderDetailLoading {
  const OrderDetailLoading();
}

@Freezed(toJson: false)
class OrderDetailError extends OrderDetailState with _$OrderDetailError {
  const OrderDetailError(this.message);

  final String message;
}

@Freezed(toJson: false)
class OrderDetailLoaded extends OrderDetailState with _$OrderDetailLoaded {
  const OrderDetailLoaded(this.detail);

  final OrderDetail detail;
}
