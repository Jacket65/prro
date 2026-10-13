import 'package:material_ui/material_ui.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/amount_row.dart';

/// Shown while the terminal charge is awaited: the "apply the card" panel with
/// the cancel control (cancelling is only meaningful while the charge has not
/// completed).
class TerminalPendingView extends StatelessWidget {
  const TerminalPendingView({
    required this.totalKopecks,
    required this.onCancel,
    super.key,
  });

  final int totalKopecks;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AmountRow(totalKopecks: totalKopecks),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: const Column(
            children: [
              Icon(Icons.credit_card, size: 64, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'Очікування оплати...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Клієнт має прикласти картку або телефон\n'
                'до терміналу PrivatBank',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            textStyle: const TextStyle(fontSize: 18),
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
          child: const Text('Скасувати оплату'),
        ),
      ],
    );
  }
}
