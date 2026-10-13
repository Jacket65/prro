import 'package:material_ui/material_ui.dart';
import 'package:prro/core/utils/money.dart';

/// The cash tender entry: an editable amount, quick-add chips, and the change
/// line. Blocking pay (and saying how much is still needed) is the form's job —
/// this view only shows what the entered amount implies.
class CashFields extends StatelessWidget {
  const CashFields({
    required this.controller,
    required this.totalKopecks,
    required this.changeKopecks,
    super.key,
  });

  final TextEditingController controller;
  final int totalKopecks;
  final int changeKopecks;

  @override
  Widget build(BuildContext context) {
    final tendered = kopecksFromString(controller.text);
    final tooLittle = tendered < totalKopecks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Внесено готівкою', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixText: '₴',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            errorText: tooLittle
                ? 'Недостатньо — потрібно щонайменше ${formatUah(totalKopecks)}'
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final amount in const [100, 200, 500, 1000])
              ActionChip(
                label: Text('+₴$amount'),
                onPressed: () {
                  final current = kopecksFromString(controller.text);
                  controller.text = formatAmount(current + amount * 100);
                },
              ),
            ActionChip(
              label: const Text('= до сплати'),
              onPressed: () {
                controller.text = formatAmount(totalKopecks);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Решта', style: TextStyle(fontSize: 18)),
            Text(
              formatUah(changeKopecks),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
