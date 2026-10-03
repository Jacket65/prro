import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/presentation/order_history/order_history_error_view.dart';
import 'package:prro/core/presentation/order_history/shifts_history_cubit.dart';
import 'package:prro/core/theme/theme.dart';

/// The shift list, shared by the seller and the admin orders tab.
///
/// Presentational: it reads a [ShiftsHistoryCubit] from the tree and reports
/// navigation through [onOpenOrders], so it knows neither the router nor which
/// feature hosts it. The screens wrap it in their own app bar.
class ShiftsHistoryView extends StatelessWidget {
  const ShiftsHistoryView({required this.onOpenOrders, super.key});

  final void Function(int shiftId) onOpenOrders;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftsHistoryCubit, ShiftsHistoryState>(
      builder: (context, state) {
        if (state is ShiftsHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ShiftsHistoryError) {
          return OrderHistoryErrorView(
            message: state.message,
            onRetry: () => context.read<ShiftsHistoryCubit>().loadFirst(),
          );
        }
        if (state is ShiftsHistoryLoaded) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Немає змін'));
          }
          return ListView.builder(
            itemCount: state.items.length + (state.hasNext ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                if (state.loadMoreError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Повторити'),
                        onPressed: () =>
                            context.read<ShiftsHistoryCubit>().loadMore(),
                      ),
                    ),
                  );
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  unawaited(context.read<ShiftsHistoryCubit>().loadMore());
                });
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final shift = state.items[index];
              return _ShiftTile(
                shift: shift,
                onTap: () => onOpenOrders(shift.id),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ShiftTile extends StatelessWidget {
  const _ShiftTile({required this.shift, required this.onTap});

  final ShiftSummary shift;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = Theme.of(context).extension<AppStatusColors>()!;
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final range = shift.closedAt == null
        ? '${dateFormat.format(shift.openedAt)} — …'
        : '${dateFormat.format(shift.openedAt)} — '
              '${dateFormat.format(shift.closedAt!)}';
    return ListTile(
      leading: const Icon(Icons.event_note),
      title: Text('Зміна №${shift.id}'),
      subtitle: Text(range),
      trailing: Chip(
        label: Text(
          shift.isOpen ? 'Відкрита' : 'Закрита',
          style: TextStyle(
            color: shift.isOpen ? status.onSuccess : status.onNeutral,
          ),
        ),
        backgroundColor: shift.isOpen ? status.success : status.neutral,
      ),
      onTap: onTap,
    );
  }
}
