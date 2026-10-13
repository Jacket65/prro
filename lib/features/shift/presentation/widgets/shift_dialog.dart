import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/core/utils/uuid.dart';
import 'package:prro/features/shift/presentation/cubit/shift_cubit.dart';

/// What the merged shift dialog does.
///
/// One widget, one cash field and one cubit call for both ends of the shift:
/// opening asks for the starting cash (`POST .../shift/open`), closing for the
/// counted cash (`POST .../shift/close`). They differed only in wording, the
/// method they call and what state means success, so those three travel with
/// the mode instead of being two dialogs that can drift apart.
enum ShiftDialogMode { open, close }

/// Asks for the till cash and opens or closes the shift. Pops `true` once the
/// backend confirms — `ShiftOpen` for [ShiftDialogMode.open], a
/// [ShiftNone] with [ShiftNoneCause.closedByUser] for
/// [ShiftDialogMode.close] (a close reported by any other cause never
/// happened and must not look successful).
class ShiftDialog extends StatefulWidget {
  const ShiftDialog({required this.mode, super.key});

  final ShiftDialogMode mode;

  static Future<bool?> show(BuildContext context, ShiftDialogMode mode) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<ShiftCubit>(),
        child: ShiftDialog(mode: mode),
      ),
    );
  }

  @override
  State<ShiftDialog> createState() => _ShiftDialogState();
}

class _ShiftDialogState extends State<ShiftDialog> {
  /// One key for the whole action (reused on retry incl. after refresh).
  final String _idempotencyKey = uuidV4();
  final TextEditingController _cashController = TextEditingController(
    text: '0.00',
  );

  bool get _isClose => widget.mode == ShiftDialogMode.close;

  String get _title => _isClose ? 'Закрити зміну' : 'Відкрити зміну';

  String get _label => _isClose
      ? 'Готівка в касі на момент закриття:'
      : 'Готівка в касі на початок зміни:';

  /// Normalized decimal string for `cash_start`/`cash_end`, e.g. "0.00",
  /// "1234.50".
  String get _cash => formatAmount(kopecksFromString(_cashController.text));

  Future<void> _confirm() async {
    final cubit = context.read<ShiftCubit>();
    if (_isClose) {
      await cubit.closeShift(cashEnd: _cash, idempotencyKey: _idempotencyKey);
    } else {
      await cubit.openShift(cashStart: _cash, idempotencyKey: _idempotencyKey);
    }
  }

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftCubit, ShiftState>(
      listener: (context, state) {
        final succeeded = _isClose
            // Only the close this dialog performed counts: a `ShiftNone` from
            // another cause (no open shift on load, session reset while the
            // dialog was open) must not pop `true` and report a close that
            // never happened.
            ? state is ShiftNone && state.cause == ShiftNoneCause.closedByUser
            : state is ShiftOpen;
        if (succeeded) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final loading = state is ShiftLoading;
        final error = state is ShiftError ? state.message : null;
        return AlertDialog(
          title: Text(_title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_label),
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
              onPressed: loading
                  ? null
                  : () => Navigator.of(context).pop(false),
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
                  : Text(_title),
            ),
          ],
        );
      },
    );
  }
}
