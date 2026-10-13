import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order.dart';

/// The cash/terminal method switch of the payment form.
class MethodSelector extends StatelessWidget {
  const MethodSelector({
    required this.method,
    required this.onChanged,
    super.key,
  });

  final PaymentMethod method;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PaymentMethod>(
      segments: const [
        ButtonSegment(
          value: PaymentMethod.cash,
          label: Text('Готівка', style: TextStyle(fontSize: 16)),
          icon: Icon(Icons.payments_outlined),
        ),
        ButtonSegment(
          value: PaymentMethod.terminal,
          label: Text('Термінал', style: TextStyle(fontSize: 16)),
          icon: Icon(Icons.credit_card),
        ),
      ],
      selected: {method},
      onSelectionChanged: (s) => onChanged(s.first),
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}
