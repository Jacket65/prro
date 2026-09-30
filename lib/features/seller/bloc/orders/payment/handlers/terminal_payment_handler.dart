import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';
import 'package:prro/services/terminal_payment_service.dart' as terminal;

/// POS terminal payment (order-first).
///
/// `pay` is a no-op: the order must exist server-side before any money moves.
/// The backend creates `type=card` orders as `pending` (no cash/stock
/// movement), so the terminal charge and the `POST /orders/{id}/confirm` both
/// happen in [afterOrderCreated]. The charge never runs before the order
/// record exists, and confirm is re-call-safe, which keeps the flow
/// money-safe.
///
/// This handler is the **strict exception boundary**: every terminal-specific
/// exception is translated into one of the two app-level boundary types
/// ([PaymentException] for failures, [PaymentCancelledException] for cancels)
/// so callers never depend on terminal internals. A catch-all guarantees that
/// even an unexpected error becomes a [PaymentException] rather than leaking a
/// raw implementation exception past the boundary.
@injectable
class TerminalPaymentHandler implements PaymentMethodHandler {
  TerminalPaymentHandler(this._terminalPaymentService, this._ordersRepository);

  final terminal.TerminalPaymentServiceI _terminalPaymentService;
  final OrdersRepositoryI _ordersRepository;

  @override
  PaymentMethod get method => PaymentMethod.terminal;

  @override
  Future<void> pay(PaymentRequest request) async {}

  @override
  Future<OrderReceipt> afterOrderCreated(
    OrderReceipt order,
    PaymentRequest request,
  ) async {
    try {
      final result = await _terminalPaymentService.startPayment(
        CreatePaymentRequest(
          amount: request.amountKopecks,
          currency: request.currency,
          description: 'Order payment',
          orderId: order.orderId,
        ),
      );
      if (!result.success) {
        throw PaymentException(
          'Оплата не пройшла: ${result.status}',
          reason: PaymentFailureReason.verificationFailed,
        );
      }
    } on terminal.PaymentCancelledException {
      // Terminal/cashier cancellation stays a cancellation.
      throw const PaymentCancelledException();
    } on terminal.TerminalPaymentException catch (e, st) {
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

    // The charge succeeded → confirm the pending order so the backend
    // completes it (that is also when stock moves). If the confirm response
    // is unusable for any reason, fall back to the pending receipt rather
    // than failing an already-paid sale (the order stays `pending`
    // server-side until confirmed; known backend gap).
    final orderId = int.tryParse(order.orderId);
    if (orderId == null) return order;
    try {
      return await _ordersRepository.confirmOrder(orderId);
    } on Object {
      return order;
    }
  }

  @override
  void cancel() => _terminalPaymentService.cancelPayment();
}
