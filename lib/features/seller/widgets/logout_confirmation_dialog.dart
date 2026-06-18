import 'package:flutter/material.dart';

/// Shows a confirmation dialog before logging out.
/// Returns `true` if the user confirmed logout, `false` otherwise.
class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const LogoutConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Вийти з акаунту'),
      content: const Text(
        'Ви впевнені, що хочете вийти? Усі незавершені дані будуть втрачені.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Скасувати'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Вийти'),
        ),
      ],
    );
  }
}
