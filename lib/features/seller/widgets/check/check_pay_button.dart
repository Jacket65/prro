import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/money.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/features/seller/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/bloc/orders/orders_bloc.dart';

class CheckPayButton extends StatelessWidget {
  const CheckPayButton({super.key});

  @override
  Widget build(BuildContext sellerContext) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final totalKopecks = state is OrdersUpdated
            ? uahToKopecks(state.total)
            : 0;
        final enabled = totalKopecks > 0;

        return SizedBox(
          width: double.infinity,
          height: 80,
          child: FilledButton(
            onPressed: enabled
                ? () => _openPaymentDialog(sellerContext, totalKopecks)
                : null,
            style: FilledButton.styleFrom(
              shape: const BeveledRectangleBorder(),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.green,
              disabledBackgroundColor: Colors.grey.shade400,
            ),
            child: Text(
              enabled ? 'ОПЛАТА ${formatUah(totalKopecks)}' : 'ОПЛАТА',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openPaymentDialog(
    BuildContext sellerContext,
    int totalKopecks,
  ) {
    return showDialog(
      context: sellerContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sellerContext.read<OrdersBloc>()),
            BlocProvider.value(value: sellerContext.read<BalanceCubit>()),
          ],
          child: PaymentDialog(totalKopecks: totalKopecks),
        );
      },
    );
  }
}

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({required this.totalKopecks, super.key});

  /// Client-side total at the moment the dialog opened. Treated as the
  /// "to charge" figure for input/validation UX; the authoritative total
  /// comes back inside the receipt after the mock processes the order.
  final int totalKopecks;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late final String _idempotencyKey;
  PaymentMethod _method = PaymentMethod.cash;
  late final TextEditingController _cashController;

  @override
  void initState() {
    super.initState();
    // One key per payment action (generated when the modal opens), reused for
    // every retry — including the auto-retry after a token refresh.
    _idempotencyKey = uuidV4();
    _cashController = TextEditingController(
      text: formatAmount(widget.totalKopecks),
    );
    _cashController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  int get _tenderedKopecks => switch (_method) {
    PaymentMethod.cash => kopecksFromString(_cashController.text),
    PaymentMethod.card => widget.totalKopecks,
  };

  int get _changeKopecks {
    final diff = _tenderedKopecks - widget.totalKopecks;
    return diff < 0 ? 0 : diff;
  }

  bool get _canPay {
    if (widget.totalKopecks <= 0) return false;
    return switch (_method) {
      PaymentMethod.cash => _tenderedKopecks >= widget.totalKopecks,
      PaymentMethod.card => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {},
      builder: (context, state) {
        final isLoading = state is OrdersLoading;

        Widget body;
        if (state is OrdersPaymentSuccess) {
          body = _SuccessView(receipt: state.receipt);
        } else {
          body = _FormView(
            totalKopecks: widget.totalKopecks,
            method: _method,
            onMethodChanged: (m) => setState(() => _method = m),
            cashController: _cashController,
            changeKopecks: _changeKopecks,
            canPay: _canPay,
            isLoading: isLoading,
            errorMessage: state is OrdersError ? state.message : null,
            onCancel: () => Navigator.of(context).pop(),
            onPay: _onPay,
          );
        }

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: body,
            ),
          ),
        );
      },
    );
  }

  void _onPay() {
    context.read<OrdersBloc>().add(
      PayOrder(
        method: _method,
        tenderedKopecks: _tenderedKopecks,
        idempotencyKey: _idempotencyKey,
      ),
    );
  }
}

// ── Form (Cash / Card) ─────────────────────────────────────────────────────

class _FormView extends StatelessWidget {
  const _FormView({
    required this.totalKopecks,
    required this.method,
    required this.onMethodChanged,
    required this.cashController,
    required this.changeKopecks,
    required this.canPay,
    required this.isLoading,
    required this.errorMessage,
    required this.onCancel,
    required this.onPay,
  });

  final int totalKopecks;
  final PaymentMethod method;
  final ValueChanged<PaymentMethod> onMethodChanged;
  final TextEditingController cashController;
  final int changeKopecks;
  final bool canPay;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onCancel;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'До оплати',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Text(
              formatUah(totalKopecks),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _MethodSelector(method: method, onChanged: onMethodChanged),
        const SizedBox(height: 20),
        if (method == PaymentMethod.cash)
          _CashFields(
            controller: cashController,
            totalKopecks: totalKopecks,
            changeKopecks: changeKopecks,
          )
        else
          _CardField(totalKopecks: totalKopecks),
        const SizedBox(height: 16),
        if (errorMessage != null) _ErrorBanner(message: errorMessage!),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(64),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Скасувати'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: (canPay && !isLoading) ? onPay : null,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(64),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text('Оплатити ${formatUah(totalKopecks)}'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MethodSelector extends StatelessWidget {
  const _MethodSelector({required this.method, required this.onChanged});

  final PaymentMethod method;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PaymentMethod>(
      segments: const [
        ButtonSegment(
          value: PaymentMethod.cash,
          label: Text('Готівка', style: TextStyle(fontSize: 16)),
          icon: Icon(Icons.payments_outlined),
        ),
        ButtonSegment(
          value: PaymentMethod.card,
          label: Text('Картка', style: TextStyle(fontSize: 16)),
          icon: Icon(Icons.credit_card),
        ),
      ],
      selected: {method},
      onSelectionChanged: (s) => onChanged(s.first),
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}

class _CashFields extends StatelessWidget {
  const _CashFields({
    required this.controller,
    required this.totalKopecks,
    required this.changeKopecks,
  });

  final TextEditingController controller;
  final int totalKopecks;
  final int changeKopecks;

  @override
  Widget build(BuildContext context) {
    final tendered = kopecksFromString(controller.text);
    final tooLittle = tendered < totalKopecks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Внесено готівкою', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixText: '₴',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            errorText: tooLittle
                ? 'Недостатньо — потрібно щонайменше ${formatUah(totalKopecks)}'
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final amount in const [100, 200, 500, 1000])
              ActionChip(
                label: Text('+₴$amount'),
                onPressed: () {
                  final current = kopecksFromString(controller.text);
                  controller.text = formatAmount(current + amount * 100);
                },
              ),
            ActionChip(
              label: const Text('= до сплати'),
              onPressed: () {
                controller.text = formatAmount(totalKopecks);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Решта', style: TextStyle(fontSize: 18)),
            Text(
              formatUah(changeKopecks),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardField extends StatelessWidget {
  const _CardField({required this.totalKopecks});

  final int totalKopecks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.credit_card, color: Colors.blue),
              SizedBox(width: 8),
              Text('Списати з картки', style: TextStyle(fontSize: 16)),
            ],
          ),
          Text(
            formatUah(totalKopecks),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade900, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Success ────────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.receipt});
  final OrderReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Оплачено',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Замовлення №${receipt.orderId}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 16),
          _ReceiptCard(receipt: receipt),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              context.read<OrdersBloc>().add(const AcknowledgePayment());
              context.read<BalanceCubit>().fetchBalance();
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size.fromHeight(64),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Готово'),
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});
  final OrderReceipt receipt;

  static const _mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    color: Colors.black87,
    height: 1.35,
  );

  String _fmtDateTime(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  String get _methodLabel => switch (receipt.method) {
    PaymentMethod.cash => 'Готівка',
    PaymentMethod.card => 'Картка',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          const SizedBox(height: 10),
          _linesTable(),
          const Divider(color: Colors.black26, height: 20),
          _totalsTable(),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text(
                  'Дякуємо за покупку!',
                  style: _mono.copyWith(fontSize: 11, color: Colors.black54),
                ),
                Text(
                  'grainsworld.click',
                  style: _mono.copyWith(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          receipt.storeName,
          style: _mono.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          'Замовлення №${receipt.orderId} · ${_fmtDateTime(receipt.issuedAt)}',
          style: _mono.copyWith(fontSize: 11, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        Text(
          'Касир: ${receipt.cashierName}',
          style: _mono.copyWith(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _linesTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(5),
        1: FlexColumnWidth(3),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black26)),
          ),
          children: [
            _cell('Товар', bold: true),
            _cell('К-сть', bold: true, align: TextAlign.center),
            _cell('Сума', bold: true, align: TextAlign.right),
          ],
        ),
        for (final l in receipt.lines)
          TableRow(
            children: [
              _cell(l.name),
              _cell(
                '${l.quantity} × ${formatUah(l.unitPriceKopecks)}',
                align: TextAlign.center,
                muted: true,
                small: true,
              ),
              _cell(
                formatUah(l.subtotalKopecks),
                align: TextAlign.right,
                bold: true,
              ),
            ],
          ),
      ],
    );
  }

  Widget _totalsTable() {
    return Table(
      columnWidths: const {0: FlexColumnWidth(), 1: IntrinsicColumnWidth()},
      children: [
        _totalRow('Разом', formatUah(receipt.totalKopecks), emphasis: true),
        _totalRow('Спосіб оплати', _methodLabel),
        _totalRow('Внесено', formatUah(receipt.tenderedKopecks)),
        _totalRow(
          'Решта',
          formatUah(receipt.changeKopecks),
          color: Colors.green.shade800,
        ),
      ],
    );
  }

  TableRow _totalRow(
    String label,
    String value, {
    bool emphasis = false,
    Color? color,
  }) {
    final style = _mono.copyWith(
      fontWeight: emphasis || color != null ? FontWeight.w700 : FontWeight.w400,
      fontSize: emphasis ? 14 : 12,
      color: color ?? (emphasis ? Colors.black87 : Colors.black54),
    );
    final valueStyle = style.copyWith(
      color: color ?? (emphasis ? Colors.black87 : Colors.black87),
      fontWeight: FontWeight.w700,
    );
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(label, style: style),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(value, style: valueStyle, textAlign: TextAlign.right),
        ),
      ],
    );
  }

  Widget _cell(
    String text, {
    bool bold = false,
    bool muted = false,
    bool small = false,
    TextAlign align = TextAlign.left,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Text(
        text,
        textAlign: align,
        style: _mono.copyWith(
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          color: muted ? Colors.black54 : Colors.black87,
          fontSize: small ? 11 : 12,
        ),
      ),
    );
  }
}
