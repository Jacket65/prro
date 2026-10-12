import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/seller/presentation/bloc/pending_order/finish_pending_order_state.dart';
import 'package:prro/features/seller/presentation/bloc/pending_order/pending_order_cubit.dart';

/// Offers to finish the card order a previous session left unfinished.
///
/// The wording never claims the charge state — the app has no way to know
/// whether the card was debited (no cancel route, no charge↔order
/// correlation), only that the *order* is still unfinished. The two actions
/// therefore do no more than their names say: confirm what is already created,
/// or drop the local record.
class PendingOrderBanner extends StatelessWidget {
  const PendingOrderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<PendingOrderCubit, PendingOrderState>(
      builder: (context, state) {
        return switch (state) {
          PendingOrderHidden() => const SizedBox.shrink(),
          PendingOrderResolving() => _banner(
            theme,
            child: const Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Expanded(child: Text('Перевіряємо оплату…')),
              ],
            ),
          ),
          PendingOrderNotice(:final message) => _banner(
            theme,
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(message)),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, size: 16),
                  tooltip: 'Закрити',
                  onPressed: () =>
                      context.read<PendingOrderCubit>().dismissNotice(),
                ),
              ],
            ),
          ),
          PendingOrderReady(
            :final orderId,
            :final totalKopecks,
            :final message,
          ) =>
            _banner(
              theme,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.credit_card, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Незавершена оплата карткою №$orderId',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  if (totalKopecks != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      formatUah(totalKopecks),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  if (message != null) ...[
                    const SizedBox(height: 4),
                    Text(message, style: theme.textTheme.bodySmall),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              context.read<PendingOrderCubit>().confirm(),
                          child: const Text('Завершити'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _confirmReject(context),
                          child: const Text('Відхилити'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        };
      },
    );
  }

  Widget _banner(ThemeData theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      color: Colors.orange[50],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: DefaultTextStyle.merge(
        style: theme.textTheme.bodyMedium,
        child: child,
      ),
    );
  }

  /// Rejecting only clears the local record: the server-side order stays
  /// `pending` and, with the shift list showing completed orders only, cannot
  /// even be found again. The seller is told that before it happens.
  Future<void> _confirmReject(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Відхилити оплату?'),
        content: const Text(
          'Замовлення залишиться неоплаченим, і його не буде видно '
          'в історії. Відновлення пізніше неможливе.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Відхилити'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    await context.read<PendingOrderCubit>().reject();
  }
}
