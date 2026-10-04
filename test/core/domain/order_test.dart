import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/domain/order.dart';

Map<String, dynamic> _line() => {
      'variant_id': 'v1',
      'name': 'Кава',
      'quantity': '2',
      'unit_price': '5.00',
      'line_total': '10.00',
      'options': [
        {'name': 'Молоко'},
        {'name': 'Сироп'},
      ],
    };

Map<String, dynamic> _payload() => {
      'order_id': '77',
      'status': 'paid',
      'created_at': '2024-05-01T12:00:00Z',
      'total_price': '12.50',
      'items': [_line()],
      'payment': {
        'method': 'cash',
        'tendered': '20.00',
        'change': '7.50',
      },
    };

void main() {
  group('ReceiptLine.fromJson', () {
    test('parses the line and its kopecks amounts', () {
      final line = ReceiptLine.fromJson(_line());
      expect(line.productId, 'v1');
      expect(line.quantity, '2');
      expect(line.unitPriceKopecks, 500);
      expect(line.subtotalKopecks, 1000);
    });

    test('appends the picked option names in wire order', () {
      final line =
          ReceiptLine.fromJson(_line());
      expect(line.name, 'Кава · Молоко, Сироп');
    });

    test('keeps the plain name when no option carries a name', () {
      final line = ReceiptLine.fromJson(const {
        'name': 'Кава',
        'options': [
          {'other': 'x'},
          {'name': ''},
        ],
      });
      expect(line.name, 'Кава');
    });

    test('defaults variant_id, quantity and the amounts', () {
      final line = ReceiptLine.fromJson(const {'name': 'Кава'});
      expect(line.productId, isEmpty);
      expect(line.quantity, '1');
      expect(line.unitPriceKopecks, 0);
      expect(line.subtotalKopecks, 0);
    });

    test('two lines from the same payload are equal', () {
      final line =
          ReceiptLine.fromJson(_line());
      expect(
        line,
        ReceiptLine.fromJson(_line()),
      );
      expect(
        line,
        isNot(
          ReceiptLine.fromJson({..._line(), 'quantity': '3'}),
        ),
      );
    });
  });

  group('OrderReceipt.fromJson', () {
    test('passes the local-only store/cashier names through', () {
      final receipt = OrderReceipt.fromJson(
        _payload(),
        storeName: 'Магазин №1',
        cashierName: 'Олена',
      );
      expect(receipt.storeName, 'Магазин №1');
      expect(receipt.cashierName, 'Олена');
    });

    test('parses ids, totals and the payment block', () {
      final receipt = OrderReceipt.fromJson(
        _payload(),
        storeName: 's',
        cashierName: 'c',
      );
      expect(receipt.orderId, '77');
      expect(receipt.status, 'paid');
      expect(receipt.totalKopecks, 1250);
      expect(receipt.tenderedKopecks, 2000);
      expect(receipt.changeKopecks, 750);
      expect(receipt.method, PaymentMethod.cash);
      expect(receipt.issuedAt, isA<DateTime>());
      expect(receipt.lines.single.name, 'Кава · Молоко, Сироп');
    });

    test('falls back to payment.total and an empty payment block', () {
      final receipt = OrderReceipt.fromJson(
        const {'total_price': '5.00'},
        storeName: 's',
        cashierName: 'c',
      );
      expect(receipt.totalKopecks, 500);
      expect(receipt.lines, isEmpty);
      expect(receipt.method, PaymentMethod.cash);
      expect(receipt.orderId, isEmpty);
      expect(receipt.status, isEmpty);
    });

    test('two receipts from the same payload are equal', () {
      OrderReceipt build() =>
          OrderReceipt.fromJson(_payload(), storeName: 's', cashierName: 'c');

      expect(build(), build());
      expect(build().hashCode, build().hashCode);
    });

    test('receipts differing in any field are not equal', () {
      OrderReceipt build({String? storeName, String? cashierName}) =>
          OrderReceipt.fromJson(
            _payload(),
            storeName: storeName ?? 's',
            cashierName: cashierName ?? 'c',
          );

      expect(build(), isNot(build(storeName: 'other')));
      expect(build(), isNot(build(cashierName: 'other')));
      expect(
        build(),
        isNot(
          OrderReceipt.fromJson(
            {..._payload(), 'total_price': '13.00'},
            storeName: 's',
            cashierName: 'c',
          ),
        ),
      );
    });
  });
}
