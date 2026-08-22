import 'package:flutter/material.dart';

/// Generic single-field text prompt. Returns the trimmed value, or `null` if
/// cancelled / empty.
Future<String?> showNameDialog(
  BuildContext context, {
  required String title,
  String? hint,
  String? initialName,
}) async {
  final controller = TextEditingController(text: initialName);
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Скасувати'),
        ),
        FilledButton(
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
