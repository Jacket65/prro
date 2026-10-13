import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/presentation/order_history/order_history_error_view.dart';
import 'package:prro/core/presentation/order_history/orders_history_cubit.dart';
import 'package:prro/core/utils/money.dart';

/// The orders of one shift, shared by the seller and the admin.
///
/// Presentational: reads an [OrdersHistoryCubit] from the tree and reports
/// navigation through [onOpenOrder].
class OrdersHistoryView extends StatelessWidget {
  const OrdersHistoryView({required this.onOpenOrder, super.key});

  final void Function(int orderId) onOpenOrder;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersHistoryCubit>();
    return Column(
      children: [
        _SortControls(cubit: cubit),
        Expanded(
          child: BlocBuilder<OrdersHistoryCubit, OrdersHistoryState>(
            builder: (context, state) {
              if (state is OrdersHistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is OrdersHistoryError) {
                return OrderHistoryErrorView(
                  message: state.message,
                  onRetry: () => context.read<OrdersHistoryCubit>().loadFirst(),
                );
              }
              if (state is OrdersHistoryLoaded) {
                if (state.items.isEmpty) {
                  return const Center(child: Text('Немає замовлень'));
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
                                  context.read<OrdersHistoryCubit>().loadMore(),
                            ),
                          ),
                        );
                      }
                      // Only schedule when no page is already being fetched
                      // (same guard as the shifts view): without it every
                      // rebuild — the loading state itself causes one — re-arms
                      // the callback for the current page.
                      if (!state.isLoadingMore) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          unawaited(
                            context.read<OrdersHistoryCubit>().loadMore(),
                          );
                        });
                      }
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final order = state.items[index];
                    return _OrderTile(
                      order: order,
                      onTap: () => onOpenOrder(order.orderId),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class _SortControls extends StatelessWidget {
  const _SortControls({required this.cubit});
  final OrdersHistoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersHistoryCubit, OrdersHistoryState>(
      builder: (context, state) {
        final sort = state is OrdersHistoryLoaded ? state.sort : cubit.sort;
        final order = state is OrdersHistoryLoaded ? state.order : cubit.order;
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('За часом'),
                selected: sort == 'created_at',
                onSelected: (_) => unawaited(cubit.setSort('created_at')),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('За сумою'),
                selected: sort == 'total_price',
                onSelected: (_) => unawaited(cubit.setSort('total_price')),
              ),
              const Spacer(),
              IconButton(
                icon: order == 'asc'
                    ? const Icon(Icons.arrow_upward)
                    : const Icon(Icons.arrow_downward),
                tooltip: order == 'asc' ? 'За зростанням' : 'За спаданням',
                onPressed: () =>
                    unawaited(cubit.setOrder(order == 'asc' ? 'desc' : 'asc')),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order, required this.onTap});

  final OrderListItem order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('dd.MM.yyyy HH:mm');
    return ListTile(
      leading: const Icon(Icons.receipt_long),
      title: Text('Чек №${order.orderId}'),
      subtitle: Text(timeFormat.format(order.createdAt)),
      trailing: Text(
        formatUah(order.totalKopecks),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
