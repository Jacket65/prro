import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/money.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/order_history.dart';

void main() {
  group('OrderListItem.fromJson', () {
    test('parses id, created_at and total_price (kopecks)', () {
      final item = OrderListItem.fromJson(const {
        'id': 42,
        'created_at': '2024-05-01T12:30:00Z',
        'total_price': '12.50',
      });
      expect(item.orderId, 42);
      expect(item.totalKopecks, kopecksFromString('12.50'));
      expect(item.createdAt, isA<DateTime>());
    });
  });

  group('ShiftSummary.fromJson', () {
    test('parses open and closed shifts', () {
      final open = ShiftSummary.fromJson(const {
        'id': 1,
        'outlet_id': 5,
        'opened_by': 3,
        'opened_at': '2024-05-01T08:00:00Z',
        'status': 'open',
      });
      expect(open.isOpen, isTrue);
      expect(open.closedAt, isNull);

      final closed = ShiftSummary.fromJson(const {
        'id': 2,
        'outlet_id': 5,
        'opened_by': 3,
        'opened_at': '2024-05-01T08:00:00Z',
        'closed_by': 4,
        'closed_at': '2024-05-01T18:00:00Z',
        'cash_end': '100.00',
        'status': 'closed',
      });
      expect(closed.isOpen, isFalse);
      expect(closed.closedAt, isNotNull);
    });
  });

  group('Page.fromJson', () {
    test('unwraps the data envelope', () {
      final page = Page<OrderListItem>.fromJson(const {
        'data': {
          'items': [
            {'id': 1, 'created_at': '2024-05-01T12:00:00Z', 'total_price': '5'},
            {'id': 2, 'created_at': '2024-05-01T13:00:00Z', 'total_price': '9'},
          ],
          'page': 1,
          'has_next': true,
          'next_page': 2,
        },
      }, OrderListItem.fromJson);
      expect(page.items.length, 2);
      expect(page.page, 1);
      expect(page.hasNext, isTrue);
      expect(page.nextPage, 2);
    });

    test('falls back to a top-level page object', () {
      final page = Page<OrderListItem>.fromJson(const {
        'items': [
          {'id': 7, 'created_at': '2024-05-01T12:00:00Z', 'total_price': '3'},
        ],
        'page': 3,
        'has_next': false,
        'next_page': null,
      }, OrderListItem.fromJson);
      expect(page.items.single.orderId, 7);
      expect(page.hasNext, isFalse);
      expect(page.nextPage, isNull);
    });
  });

  group('OrderDetail.fromJson', () {
    test('parses items, options and payment (kopecks)', () {
      final detail = OrderDetail.fromJson(const {
        'id': 99,
        'shift_id': 5,
        'status': 'paid',
        'created_at': '2024-05-01T12:00:00Z',
        'total_price': '10.00',
        'items': [
          {
            'name': 'Кава',
            'quantity': '2',
            'unit_price': '4.00',
            'line_total': '8.00',
            'variant_id': 'v1',
            'options': [
              {'name': 'Молоко', 'price_delta': '2.00', 'quantity': 1},
            ],
          },
        ],
        'payment': {
          'method': 'cash',
          'tendered': '12.00',
          'change': '2.00',
          'total': '10.00',
        },
      });
      expect(detail.orderId, 99);
      expect(detail.items.length, 1);
      expect(detail.items.first.options.first.priceDeltaKopecks, 200);
      expect(detail.payment.method, PaymentMethod.cash);
      expect(detail.payment.tenderedKopecks, 1200);
      expect(detail.totalKopecks, 1000);
    });
  });
}
