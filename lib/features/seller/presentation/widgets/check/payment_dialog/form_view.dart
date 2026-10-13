import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/amount_row.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/cash_fields.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/error_banner.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/method_selector.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/terminal_field.dart';

/// The editable payment form: amount row, method switch, the method's panel,
/// an optional error banner, and the cancel/pay actions.
///
/// The dialog owns the state (method, cash text, validation); this view is a
/// pure function of it.
class FormView extends StatelessWidget {
  const FormView({
    required this.totalKopecks,
    required this.method,
    required this.onMethodChanged,
    required this.cashController,
    required this.changeKopecks,
    required this.canPay,
    required this.errorMessage,
    required this.onCancel,
    required this.onPay,
    super.key,
  });

  final int totalKopecks;
  final PaymentMethod method;
  final ValueChanged<PaymentMethod> onMethodChanged;
  final TextEditingController cashController;
  final int changeKopecks;
  final bool canPay;
  final String? errorMessage;
  final VoidCallback onCancel;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AmountRow(totalKopecks: totalKopecks),
        const SizedBox(height: 16),
        MethodSelector(method: method, onChanged: onMethodChanged),
        const SizedBox(height: 20),
        if (method == PaymentMethod.cash)
          CashFields(
            controller: cashController,
            totalKopecks: totalKopecks,
            changeKopecks: changeKopecks,
          )
        else
          TerminalField(totalKopecks: totalKopecks),
        if (errorMessage != null) ...[
          const SizedBox(height: 16),
          ErrorBanner(message: errorMessage!),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(64),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Скасувати'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: canPay ? onPay : null,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(64),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text('Оплатити ${formatUah(totalKopecks)}'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
