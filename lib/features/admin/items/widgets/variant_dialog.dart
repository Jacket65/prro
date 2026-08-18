import 'package:flutter/material.dart';
import 'package:prro/core/money.dart';

/// Add a variant. Returns `(name, priceKopecks)`, or `null` if cancelled.
/// Price is entered in UAH and converted to kopecks via [uahToKopecks].
Future<(String name, int priceKopecks)?> showVariantDialog(
  BuildContext context,
) async {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  final result = await showDialog<(String, int)>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Новий варіант'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Назва варіанта'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Ціна, грн',
              suffixText: 'грн',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final price =
                double.tryParse(
                  priceController.text.trim().replaceAll(',', '.'),
                ) ??
                0;
            if (name.isEmpty) return;
            Navigator.of(ctx).pop((name, uahToKopecks(price)));
          },
          child: const Text('Зберегти'),
        ),
      ],
    ),
  );

  nameController.dispose();
  priceController.dispose();
  return result;
}
