import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';

/// Cash payments are finalized by the backend inside `placeOrder`, so there is
/// no method-specific step to perform here; the receipt comes back complete.
@injectable
class CashPaymentHandler implements PaymentMethodHandler {
  @override
  PaymentMethod get method => PaymentMethod.cash;

  @override
  Future<void> pay(PaymentRequest request) async {}

  @override
  Future<OrderReceipt> afterOrderCreated(
    OrderReceipt order,
    PaymentRequest request,
  ) async => order;

  @override
  void cancel() {}
}
