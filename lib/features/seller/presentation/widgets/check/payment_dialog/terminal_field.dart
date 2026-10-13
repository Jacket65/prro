import 'package:material_ui/material_ui.dart';
import 'package:prro/core/utils/money.dart';

/// The terminal method's panel: the charge goes to the POS terminal for the
/// full amount, so the view carries no entry — only what will be charged.
class TerminalField extends StatelessWidget {
  const TerminalField({required this.totalKopecks, super.key});

  final int totalKopecks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Flexible on narrower surfaces (a phone in portrait): the label
          // ellipsizes instead of overflowing the row.
          const Flexible(
            child: Row(
              children: [
                Icon(Icons.credit_card, color: Colors.blue),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Оплата через термінал',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatUah(totalKopecks),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
