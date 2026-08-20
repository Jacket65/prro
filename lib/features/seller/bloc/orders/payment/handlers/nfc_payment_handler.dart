import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';
import 'package:prro/services/nfc_payment_service.dart' as nfc;

/// NFC POS payment: launches the PrivatBank terminal and waits for the customer
/// to pay there.
///
/// Every NFC-specific exception is translated into one of the two app-level
/// boundary types ([PaymentException] for failures, [PaymentCancelledException]
/// for cancels) so callers never depend on terminal internals.
@injectable
class NfcPaymentHandler implements PaymentMethodHandler {
  NfcPaymentHandler(this._nfcPaymentService);

  final nfc.NfcPaymentServiceI _nfcPaymentService;

  @override
  PaymentMethod get method => PaymentMethod.nfc;

  @override
  Future<void> pay(PaymentRequest request) async {
    try {
      final result = await _nfcPaymentService.startPayment(
        CreatePaymentRequest(
          amount: request.amountKopecks,
          currency: request.currency,
          description: 'Order payment',
        ),
      );
      if (!result.success) {
        throw PaymentException('Оплата не пройшла: ${result.status}');
      }
    } on nfc.PaymentCancelledException {
      throw const PaymentCancelledException();
    } on nfc.TerminalLaunchFailedException catch (e) {
      throw PaymentException(e.message);
    } on nfc.PaymentTerminalFailureException catch (e) {
      throw PaymentException(e.message);
    } on nfc.PaymentCallbackTimeoutException catch (e) {
      throw PaymentException(e.message);
    } on nfc.InvalidCallbackException catch (e) {
      throw PaymentException(e.message);
    } on nfc.PaymentAlreadyInProgressException catch (e) {
      throw PaymentException(e.message);
    }
  }

  @override
  void cancel() => _nfcPaymentService.cancelPayment();
}
