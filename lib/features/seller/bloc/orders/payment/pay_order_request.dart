import 'package:prro/data/api/models/models.dart';

/// UI → application request to pay for the current cart.
///
/// Carries exactly what `OrdersBloc` knows at pay time: the chosen method, the
/// tendered amount, and the idempotency key generated when the payment dialog
/// opened. The charge amount is derived inside `PayOrderUseCase` from the live
/// cart total, so no `amount` field is duplicated here.
final class PayOrderRequest {
  const PayOrderRequest({
    required this.method,
    required this.tenderedKopecks,
    required this.idempotencyKey,
  });

  final PaymentMethod method;
  final int tenderedKopecks;
  final String idempotencyKey;
}
