import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/utils/money.dart';

/// The printed-receipt preview on the success panel.
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({required this.receipt, super.key});

  final OrderReceipt receipt;

  static const _mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    color: Colors.black87,
    height: 1.35,
  );

  String _fmtDateTime(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');

    return '${two(d.day)}.${two(d.month)}.${d.year} '
        '${two(d.hour)}:${two(d.minute)}';
  }

  String get _methodLabel => switch (receipt.method) {
    PaymentMethod.cash => 'Готівка',
    PaymentMethod.terminal => 'Термінал',
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
                  'pos.coffeebeans.space',
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
      color: color ?? Colors.black87,
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
