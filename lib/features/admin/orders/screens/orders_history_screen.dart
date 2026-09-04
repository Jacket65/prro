import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prro/core/money.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:prro/data/repositories/order_history/order_history.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/orders/bloc/orders_history_cubit.dart';
import 'package:prro/features/admin/widgets/admin_back_button.dart';
import 'package:prro/router/app_router.gr.dart';

@RoutePage(name: 'AdminOrdersHistoryRoute')
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({required this.shiftId, super.key});
  final int shiftId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = OrdersHistoryCubit(
          getIt<OrderHistoryRepositoryI>(),
          shiftId,
        );
        unawaited(cubit.loadFirst());
        return cubit;
      },
      child: const _OrdersHistoryView(),
    );
  }
}

class _OrdersHistoryView extends StatelessWidget {
  const _OrdersHistoryView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersHistoryCubit>();
    return Scaffold(
      appBar: AppBar(
        leading: const AdminBackButton(),

        title: const Text('Замовлення зміни'),
      ),
      body: Column(
        children: [
          _SortControls(cubit: cubit),
          Expanded(
            child: BlocBuilder<OrdersHistoryCubit, OrdersHistoryState>(
              builder: (context, state) {
                if (state is OrdersHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is OrdersHistoryError) {
                  return _ErrorView(
                    message: state.message,
                    onRetry: () =>
                        context.read<OrdersHistoryCubit>().loadFirst(),
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
                                onPressed: () => context
                                    .read<OrdersHistoryCubit>()
                                    .loadMore(),
                              ),
                            ),
                          );
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          unawaited(
                            context.read<OrdersHistoryCubit>().loadMore(),
                          );
                        });
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final order = state.items[index];
                      return _OrderTile(order: order);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
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
  const _OrderTile({required this.order});
  final OrderListItem order;

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
      onTap: () => context.router.push(
        AdminOrderDetailRoute(orderId: order.orderId),
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
          Icon(
            Icons.error_outline,
            size: 56,
            color: Theme.of(context).colorScheme.error,
          ),
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
