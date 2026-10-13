import 'package:material_ui/material_ui.dart';
import 'package:prro/features/seller/presentation/widgets/check/payment_dialog/amount_row.dart';

/// The spinner shown while a cash payment is being booked.
class GenericProcessingView extends StatelessWidget {
  const GenericProcessingView({required this.totalKopecks, super.key});

  final int totalKopecks;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AmountRow(totalKopecks: totalKopecks),
        const SizedBox(height: 32),
        const Center(child: CircularProgressIndicator(strokeWidth: 3)),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Оплата...',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
