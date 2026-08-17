import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:prro/features/admin/orders/bloc/shifts_history_cubit.dart';
import 'package:prro/features/admin/orders/screens/orders_history_screen.dart';

class ShiftsHistoryScreen extends StatelessWidget {
  const ShiftsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => const _ShiftsHistoryView();
}

class _ShiftsHistoryView extends StatelessWidget {
  const _ShiftsHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Історія змін')),
      body: BlocBuilder<ShiftsHistoryCubit, ShiftsHistoryState>(
        builder: (context, state) {
          if (state is ShiftsHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ShiftsHistoryError) {
            return _ErrorView(
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
                return _ShiftTile(shift: shift);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ShiftTile extends StatelessWidget {
  const _ShiftTile({required this.shift});
  final ShiftSummary shift;

  @override
  Widget build(BuildContext context) {
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
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: shift.isOpen ? Colors.green : Colors.grey,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => OrdersHistoryScreen(shiftId: shift.id),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Спробувати ще раз'),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
