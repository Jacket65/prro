import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prro/core/money.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:prro/data/repositories/order_history/order_history.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/orders/bloc/order_detail_cubit.dart';
import 'package:prro/features/admin/widgets/admin_back_button.dart';

@RoutePage(name: 'AdminOrderDetailRoute')
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({required this.orderId, super.key});
  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = OrderDetailCubit(getIt<OrderHistoryRepositoryI>());
        unawaited(cubit.load(orderId));
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const AdminBackButton(),

          title: Text('Чек №$orderId'),
        ),
        body: BlocBuilder<OrderDetailCubit, OrderDetailState>(
          builder: (context, state) {
            if (state is OrderDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrderDetailError) {
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
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Спробувати ще раз'),
                      onPressed: () =>
                          context.read<OrderDetailCubit>().load(orderId),
                    ),
                  ],
                ),
              );
            }
            if (state is OrderDetailLoaded) {
              return _OrderDetailView(detail: state.detail);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _OrderDetailView extends StatelessWidget {
  const _OrderDetailView({required this.detail});
  final OrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('dd.MM.yyyy HH:mm');
    final methodLabel = switch (detail.payment.method) {
      PaymentMethod.cash => 'Готівка',
      PaymentMethod.card => 'Карта',
      PaymentMethod.nfc => 'NFC',
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Chip(label: Text(detail.status)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                timeFormat.format(detail.createdAt),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Позиції',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Divider(),
        for (final item in detail.items) ...[
          _ItemRow(item: item),
          const SizedBox(height: 8),
        ],
        const Divider(),
        _TotalRow(
          label: 'Разом',
          value: formatUah(detail.totalKopecks),
          bold: true,
        ),
        _TotalRow(label: 'Спосіб оплати', value: methodLabel),
        _TotalRow(
          label: 'Внесено',
          value: formatUah(detail.payment.tenderedKopecks),
        ),
        _TotalRow(
          label: 'Решта',
          value: formatUah(detail.payment.changeKopecks),
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final OrderDetailItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(item.name)),
            Text(formatUah(item.lineTotalKopecks)),
          ],
        ),
        Text(
          '${item.quantity} × ${formatUah(item.unitPriceKopecks)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        for (final option in item.options)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              '• ${option.name} (+${formatUah(option.priceDeltaKopecks)})',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
  });
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null,
            ),
          ),
          Text(
            value,
            style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null,
          ),
        ],
      ),
    );
  }
}
