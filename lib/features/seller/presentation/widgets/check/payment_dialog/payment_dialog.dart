import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/core/utils/uuid.dart';
import 'package:prro/features/seller/presentation/bloc/orders/orders_bloc.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/form_view.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/processing_view.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/success_view.dart';

/// The payment modal: one dialog for both methods (cash and terminal), the
/// three result states (form, processing, success) and the error retry.
///
/// The state lives here (method, tender text, the idempotency key); the views
/// are pure functions of it and live in sibling files.
class PaymentDialog extends StatefulWidget {
  const PaymentDialog({required this.totalKopecks, super.key});

  /// Client-side total at the moment the dialog opened. Treated as the
  /// "to charge" figure for input/validation UX; the authoritative total
  /// comes back inside the receipt after the order is processed.
  final int totalKopecks;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late final String _idempotencyKey;
  late final TextEditingController _cashController;
  PaymentMethod _method = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    // One key per dialog instance (generated when the modal opens) and reused
    // for every retry. This is intentional and safe: the backend treats the
    // key as "one logical order placement". Reusing it makes `placeOrder`
    // idempotent — a retried placement (e.g. after a transient network error)
    // returns the same order instead of creating a duplicate, and if the first
    // attempt actually succeeded server-side but the client saw a failure, the
    // retry safely returns that existing order rather than charging twice.
    // The key is NOT regenerated between retries for this reason.
    _idempotencyKey = uuidV4();
    _cashController = TextEditingController(
      text: formatAmount(widget.totalKopecks),
    );
  }

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  int get _tenderedKopecks => switch (_method) {
    PaymentMethod.cash => kopecksFromString(_cashController.text),
    PaymentMethod.terminal => widget.totalKopecks,
  };

  int get _changeKopecks {
    final diff = _tenderedKopecks - widget.totalKopecks;
    return diff < 0 ? 0 : diff;
  }

  bool get _canPay {
    if (widget.totalKopecks <= 0) return false;
    return switch (_method) {
      PaymentMethod.cash => _tenderedKopecks >= widget.totalKopecks,
      PaymentMethod.terminal => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {},
      builder: (context, state) {
        final isProcessing = state is OrdersPaymentProcessing;
        final isSuccess = state is OrdersPaymentSuccess;

        return PopScope(
          canPop:
              !isProcessing && !isSuccess, // Block dismissal while processing
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            insetPadding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: isSuccess
                    ? SuccessView(receipt: state.receipt)
                    : isProcessing
                    ? ProcessingView(
                        method: state.method,
                        totalKopecks: widget.totalKopecks,
                        onCancel: state.method == PaymentMethod.terminal
                            ? () => context.read<OrdersBloc>().add(
                                const CancelPayment(),
                              )
                            : null,
                      )
                    : ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _cashController,
                        builder: (context, _, _) {
                          return FormView(
                            totalKopecks: widget.totalKopecks,
                            method: _method,
                            onMethodChanged: (m) => setState(() => _method = m),
                            cashController: _cashController,
                            changeKopecks: _changeKopecks,
                            canPay: _canPay,
                            errorMessage: state is OrdersError
                                ? state.message
                                : null,
                            onCancel: () => Navigator.of(context).pop(),
                            onPay: _onPay,
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPay() {
    context.read<OrdersBloc>().add(
      PayOrder(
        method: _method,
        tenderedKopecks: _tenderedKopecks,
        idempotencyKey: _idempotencyKey,
      ),
    );
  }
}
