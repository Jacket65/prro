import 'package:material_ui/material_ui.dart';
import 'package:prro/core/utils/money.dart';

/// The "До оплати {amount}" row shared by the form and the processing views.
///
/// The three copies of this row were verbatim identical; the template step of
/// the change made the amounts and the total agree across them.
class AmountRow extends StatelessWidget {
  const AmountRow({required this.totalKopecks, super.key});

  final int totalKopecks;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'До оплати',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        Text(
          formatUah(totalKopecks),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
