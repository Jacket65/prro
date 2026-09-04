import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/api/models/payment/payment_result.dart';
import 'package:prro/data/api/models/payment/payment_token.dart';
import 'package:prro/data/repositories/payment_repository/payment_repo_i.dart';
import 'package:prro/data/services/payment_service.dart';

/// Production implementation of [PaymentRepositoryI].
@LazySingleton(
  as: PaymentRepositoryI,
  env: [Environment.prod],
)
class PaymentRepositoryImpl implements PaymentRepositoryI {
  PaymentRepositoryImpl(this._paymentService);

  final PaymentServiceI _paymentService;

  @override
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request) {
    return _paymentService.createPaymentToken(request);
  }

  @override
  Future<PaymentResult> verifyPayment(String transactionId) {
    return _paymentService.verifyPayment(transactionId);
  }
}
