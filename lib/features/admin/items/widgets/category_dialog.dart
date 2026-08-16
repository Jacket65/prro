import 'package:flutter/material.dart';

/// Add / rename a category. Returns the trimmed name, or `null` if cancelled.
Future<String?> showCategoryDialog(
  BuildContext context, {
  String? initialName,
}) async {
  final controller = TextEditingController(text: initialName);
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        initialName == null ? 'Нова категорія' : 'Перейменувати категорію',
      ),
      content: TextField(
        autofocus: true,
        controller: controller,
        decoration: const InputDecoration(hintText: 'Назва категорії'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Скасувати'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
          child: const Text('Зберегти'),
        ),
      ],
    ),
  );
  controller.dispose();
  if (name == null || name.isEmpty) return null;
  return name;
}
