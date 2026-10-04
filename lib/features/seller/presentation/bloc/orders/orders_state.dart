part of 'orders_bloc.dart';

sealed class OrdersState {
  const OrdersState();
}

@Freezed(toJson: false)
class OrdersInitial extends OrdersState with _$OrdersInitial {
  const OrdersInitial();
}

@Freezed(toJson: false)
class OrdersLoading extends OrdersState with _$OrdersLoading {
  const OrdersLoading({this.products = const []});

  final List<Product> products;
}

@Freezed(toJson: false)
class OrdersUpdated extends OrdersState with _$OrdersUpdated {
  const OrdersUpdated({required this.products, required this.total});

  final List<Product> products;
  final double total;
}

/// Payment finished — cart has been cleared, receipt is shown to the cashier.
@Freezed(toJson: false)
class OrdersPaymentSuccess extends OrdersState with _$OrdersPaymentSuccess {
  const OrdersPaymentSuccess(this.receipt);

  final OrderReceipt receipt;
}

/// A payment is being processed for the current cart (any method). The dialog
/// renders a method-specific view from [method] + [total].
@Freezed(toJson: false)
class OrdersPaymentProcessing extends OrdersState
    with _$OrdersPaymentProcessing {
  const OrdersPaymentProcessing({required this.method, required this.total});

  final PaymentMethod method;
  final double total;
}

@Freezed(toJson: false)
class OrdersError extends OrdersState with _$OrdersError {
  const OrdersError({
    required this.message,
    required this.products,
    required this.total,
  });

  final String message;
  final List<Product> products;
  final double total;
}
