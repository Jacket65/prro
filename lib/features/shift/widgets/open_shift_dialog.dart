import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/money.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/features/shift/bloc/bloc.dart';

/// Asks for the starting cash and opens a shift (`POST .../shift/open`).
/// Pops `true` once the backend confirms (201 → [ShiftOpen]).
class OpenShiftDialog extends StatefulWidget {
  const OpenShiftDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<ShiftCubit>(),
        child: const OpenShiftDialog(),
      ),
    );
  }

  @override
  State<OpenShiftDialog> createState() => _OpenShiftDialogState();
}

class _OpenShiftDialogState extends State<OpenShiftDialog> {
  /// One key for the whole open action (reused on retry incl. after refresh).
  final String _idempotencyKey = uuidV4();
  final TextEditingController _cashController = TextEditingController(
    text: '0.00',
  );

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  /// Normalized decimal string for `cash_start`, e.g. "0.00", "1234.50".
  String get _cashStart => formatAmount(kopecksFromString(_cashController.text));

  void _confirm() {
    context.read<ShiftCubit>().openShift(
      cashStart: _cashStart,
      idempotencyKey: _idempotencyKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftCubit, ShiftState>(
      listener: (context, state) {
        if (state is ShiftOpen) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final loading = state is ShiftLoading;
        final error = state is ShiftError ? state.message : null;
        return AlertDialog(
          title: const Text('Відкрити зміну'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Готівка в касі на початок зміни:'),
              const SizedBox(height: 8),
              TextField(
                controller: _cashController,
                autofocus: true,
                enabled: !loading,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixText: '₴',
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  error,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: loading ? null : () => Navigator.of(context).pop(false),
              child: const Text('Скасувати'),
            ),
            FilledButton(
              onPressed: loading ? null : _confirm,
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Відкрити зміну'),
            ),
          ],
        );
      },
    );
  }
}
