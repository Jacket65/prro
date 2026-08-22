import 'package:flutter/material.dart';

/// Generic single-field text prompt. Returns the trimmed value, or `null` if
/// cancelled / empty.
Future<String?> showNameDialog(
  BuildContext context, {
  required String title,
  String? hint,
  String? initialName,
}) async {
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => _NameDialogContent(
      title: title,
      hint: hint,
      initialName: initialName,
    ),
  );
  if (name == null || name.isEmpty) return null;
  return name;
}

class _NameDialogContent extends StatefulWidget {
  const _NameDialogContent({
    required this.title,
    this.hint,
    this.initialName,
  });

  final String title;
  final String? hint;
  final String? initialName;

  @override
  State<_NameDialogContent> createState() => _NameDialogContentState();
}

class _NameDialogContentState extends State<_NameDialogContent> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        autofocus: true,
        controller: _controller,
        decoration: InputDecoration(hintText: widget.hint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
