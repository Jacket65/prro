import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/utils/money.dart';

void main() {
  group('OrderListItem.fromJson', () {
    test('parses order_id, created_at and total_price (kopecks)', () {
      final item = OrderListItem.fromJson(const {
        'order_id': 42,
        'created_at': '2024-05-01T12:30:00Z',
        'total_price': '12.50',
      });
      expect(item.orderId, 42);
      expect(item.totalKopecks, kopecksFromString('12.50'));
      expect(item.createdAt, isA<DateTime>());
    });

    test('falls back to the legacy id key', () {
      final item = OrderListItem.fromJson(const {
        'id': 42,
        'created_at': '2024-05-01T12:30:00Z',
        'total_price': '12.50',
      });
      expect(item.orderId, 42);
    });

    test('prefers order_id over id', () {
      final item = OrderListItem.fromJson(const {
        'order_id': 7,
        'id': 99,
        'created_at': '2024-05-01T12:30:00Z',
        'total_price': '1.00',
      });
      expect(item.orderId, 7);
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

    test('keeps cash_end as the text the backend sent', () {
      expect(
        ShiftSummary.fromJson(
          const {'id': 2, 'cash_end': '100.00'},
        ).cashEnd,
        '100.00',
      );
      expect(
        ShiftSummary.fromJson(const {'id': 2, 'cash_end': 100}).cashEnd,
        '100',
      );
      expect(ShiftSummary.fromJson(const {'id': 2}).cashEnd, isNull);
    });

    test('a missing or malformed opened_at falls back to now', () {
      expect(
        ShiftSummary.fromJson(const {'id': 1}).openedAt.isAfter(
              DateTime.now().subtract(const Duration(minutes: 1)),
            ),
        isTrue,
      );
      expect(
        ShiftSummary.fromJson(const {'id': 1, 'opened_at': 'nope'}).openedAt,
        isA<DateTime>(),
      );
    });

    test('two summaries from the same payload are equal', () {
      Map<String, dynamic> payload() => {
            'id': 2,
            'outlet_id': 5,
            'opened_by': 3,
            'opened_at': '2024-05-01T18:00:00Z',
            'closed_by': 4,
            'closed_at': '2024-05-01T19:00:00Z',
            'cash_end': '100.00',
            'status': 'closed',
          };
      expect(
        ShiftSummary.fromJson(payload()),
        ShiftSummary.fromJson(payload()),
      );
      expect(
        ShiftSummary.fromJson(payload()),
        isNot(ShiftSummary.fromJson({...payload(), 'cash_end': '110.00'})),
      );
    });
  });

  group('Page.fromJson', () {
    test('unwraps the data envelope', () {
      final page = Page<OrderListItem>.fromJson(const {
        'data': {
          'items': [
            {
              'order_id': 1,
              'created_at': '2024-05-01T12:00:00Z',
              'total_price': '5',
            },
            {
              'order_id': 2,
              'created_at': '2024-05-01T13:00:00Z',
              'total_price': '9',
            },
          ],
          'page': 1,
          'has_next': true,
          'next_page': 2,
        },
      }, OrderListItem.fromJson);
      expect(page.items.length, 2);
      expect(page.items.map((i) => i.orderId), [1, 2]);
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

    test('a missing quantity decodes as a single portion', () {
      final detail = OrderDetail.fromJson(const {
        'id': 1,
        'items': [
          {'name': 'Кава'},
        ],
      });
      expect(detail.items.single.quantity, '1');
      expect(detail.items.single.options, isEmpty);
      expect(detail.items.single.variantId, isEmpty);
      expect(detail.totalKopecks, 0);
    });

    test('a missing option quantity decodes as one', () {
      expect(
        OrderDetailOption.fromJson(const {'name': 'Молоко'}).quantity,
        1,
      );
    });

    test('a card or nfc method decodes as terminal', () {
      for (final wire in ['card', 'nfc']) {
        expect(
          OrderDetailPayment.fromJson({'method': wire}).method,
          PaymentMethod.terminal,
          reason: wire,
        );
      }
      expect(
        OrderDetailPayment.fromJson(const {}).method,
        PaymentMethod.cash,
      );
    });

    test('two details from the same payload are equal', () {
      Map<String, dynamic> payload() => {
            'id': 99,
            'shift_id': 5,
            'status': 'paid',
            'created_at': '2024-05-01T12:00:00Z',
            'total_price': '10.00',
            'items': [
              {'name': 'Кава', 'quantity': '2', 'variant_id': 'v1'},
            ],
            'payment': {'method': 'cash', 'total': '10.00'},
          };
      expect(OrderDetail.fromJson(payload()), OrderDetail.fromJson(payload()));
      expect(
        OrderDetail.fromJson(payload()),
        isNot(OrderDetail.fromJson({...payload(), 'total_price': '11.00'})),
      );
    });
  });

  group('Page equality', () {
    OrderListItem item(int orderId) => OrderListItem(
          orderId: orderId,
          createdAt: DateTime(2024, 5),
          totalKopecks: 100,
        );

    test('pages with the same content are equal', () {
      expect(
        Page<OrderListItem>(
          items: [item(1)],
          page: 1,
          hasNext: false,
        ),
        Page<OrderListItem>(
          items: [item(1)],
          page: 1,
          hasNext: false,
        ),
      );
    });

    test('pages differing in items, page, hasNext or nextPage are not', () {
      final page = Page<OrderListItem>(
        items: [item(1)],
        page: 1,
        hasNext: false,
      );
      expect(
        page,
        isNot(Page<OrderListItem>(items: [item(2)], page: 1, hasNext: false)),
      );
      expect(
        page,
        isNot(Page<OrderListItem>(items: [item(1)], page: 2, hasNext: false)),
      );
      expect(
        page,
        isNot(Page<OrderListItem>(items: [item(1)], page: 1, hasNext: true)),
      );
      expect(
        page,
        isNot(
          Page<OrderListItem>(
            items: [item(1)],
            page: 1,
            hasNext: false,
            nextPage: 2,
          ),
        ),
      );
    });
  });
}
