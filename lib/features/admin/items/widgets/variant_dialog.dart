import 'package:flutter/material.dart';
import 'package:prro/core/money.dart';

/// Add a variant. Returns `(name, priceKopecks)`, or `null` if cancelled.
/// Price is entered in UAH and converted to kopecks via [uahToKopecks].
Future<(String name, int priceKopecks)?> showVariantDialog(
  BuildContext context,
) async {
  return showDialog<(String, int)>(
    context: context,
    builder: (ctx) => const _VariantDialogContent(),
  );
}

class _VariantDialogContent extends StatefulWidget {
  const _VariantDialogContent();

  @override
  State<_VariantDialogContent> createState() => _VariantDialogContentState();
}

class _VariantDialogContentState extends State<_VariantDialogContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новий варіант'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Назва варіанта'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final price =
                double.tryParse(
                  _priceController.text.trim().replaceAll(',', '.'),
                ) ??
                0;
            if (name.isEmpty) return;
            Navigator.of(context).pop((name, uahToKopecks(price)));
          },
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
