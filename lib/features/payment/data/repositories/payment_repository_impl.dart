import 'package:injectable/injectable.dart';
import 'package:prro/features/payment/data/models/payment_request.dart';
import 'package:prro/features/payment/data/models/payment_result.dart';
import 'package:prro/features/payment/data/models/payment_token.dart';
import 'package:prro/features/payment/data/services/payment_service.dart';
import 'package:prro/features/payment/domain/repositories/payment_repository_i.dart';

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
