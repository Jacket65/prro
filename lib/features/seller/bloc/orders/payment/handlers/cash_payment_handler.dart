import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';

/// Cash payments are finalized by the backend inside `placeOrder`, so there is
/// no method-specific step to perform here.
@injectable
class CashPaymentHandler implements PaymentMethodHandler {
  @override
  PaymentMethod get method => PaymentMethod.cash;

  @override
  Future<void> pay(PaymentRequest request) async {}

  @override
  void cancel() {}
}
