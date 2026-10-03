import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/presentation/order_history/order_detail_cubit.dart';
import 'package:prro/core/presentation/order_history/order_history_error_view.dart';
import 'package:prro/core/utils/money.dart';

/// One receipt, shared by the seller and the admin.
///
/// [orderId] is needed by the retry, which re-runs the cubit's load.
class OrderDetailView extends StatelessWidget {
  const OrderDetailView({required this.orderId, super.key});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailCubit, OrderDetailState>(
      builder: (context, state) {
        if (state is OrderDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrderDetailError) {
          return OrderHistoryErrorView(
            message: state.message,
            onRetry: () => context.read<OrderDetailCubit>().load(orderId),
          );
        }
        if (state is OrderDetailLoaded) {
          return _OrderDetailBody(detail: state.detail);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({required this.detail});

  final OrderDetail detail;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('dd.MM.yyyy HH:mm');
    final methodLabel = switch (detail.payment.method) {
      PaymentMethod.cash => 'Готівка',
      PaymentMethod.terminal => 'Термінал',
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
    final muted = TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      fontSize: 13,
    );
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
          style: muted,
        ),
        for (final option in item.options)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              '• ${option.name} (+${formatUah(option.priceDeltaKopecks)})',
              style: muted,
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
