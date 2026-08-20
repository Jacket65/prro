import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';
import 'package:prro/services/nfc_payment_service.dart' as nfc;

/// NFC POS payment: launches the PrivatBank terminal and waits for the customer
/// to pay there.
///
/// This handler is the **strict exception boundary**: every NFC-specific
/// exception is translated into one of the two app-level boundary types
/// ([PaymentException] for failures, [PaymentCancelledException] for cancels)
/// so callers never depend on terminal internals. A catch-all guarantees that
/// even an unexpected error becomes a [PaymentException] rather than leaking a
/// raw implementation exception past the boundary.
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
        throw PaymentException(
          'Оплата не пройшла: ${result.status}',
          reason: PaymentFailureReason.verificationFailed,
        );
      }
    } on nfc.PaymentCancelledException {
      // Terminal/cashier cancellation stays a cancellation.
      throw const PaymentCancelledException();
    } on nfc.NfcPaymentException catch (e, st) {
      // All well-defined terminal/callback/repository failures map to a single
      // boundary type, preserving the machine-readable reason and the original
      // cause + stack trace for diagnostics.
      throw PaymentException(
        e.message,
        reason: e.reason,
        cause: e,
        stackTrace: st,
      );
    } on PaymentException {
      // Already a boundary type (e.g. a translated failure from a deeper
      // layer); forward unchanged.
      rethrow;
    } on Object catch (e, st) {
      // Defense in depth: never let an unexpected error escape the boundary.
      throw PaymentException(
        'Не вдалося оплатити.',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  void cancel() => _nfcPaymentService.cancelPayment();
}
