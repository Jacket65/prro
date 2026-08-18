import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/order_history.dart';
import 'package:prro/data/services/order_history_service.dart';

@Environment('mock')
@Singleton(as: OrderHistoryServiceI)
class OrderHistoryServiceMock implements OrderHistoryServiceI {
  OrderHistoryServiceMock();

  static const int _shiftsCount = 4;
  static const int _ordersPerShift = 33;
  static const int _pageSize = 10;

  final List<ShiftSummary> _shifts = [];
  final Map<int, List<OrderListItem>> _orders = {};
  final Map<int, OrderDetail> _orderDetails = {};

  List<ShiftSummary> _getShifts() {
    if (_shifts.isNotEmpty) return _shifts;
    final now = DateTime.now();
    for (var i = 0; i < _shiftsCount; i++) {
      final opened = now.subtract(Duration(days: _shiftsCount - i, hours: 9));
      final open = i == _shiftsCount - 1;
      _shifts.add(
        ShiftSummary(
          id: 1000 + i,
          outletId: 1,
          openedBy: 1,
          openedAt: opened,
          closedBy: open ? null : 1,
          closedAt: open ? null : opened.add(const Duration(hours: 9)),
          cashEnd: open ? null : '${100 + i * 10}.00',
          status: open ? 'open' : 'closed',
        ),
      );
    }
    return _shifts;
  }

  List<OrderListItem> _getOrders(int shiftId) {
    final cached = _orders[shiftId];
    if (cached != null) return cached;
    final shift = _getShifts().firstWhere(
      (s) => s.id == shiftId,
      orElse: () => _getShifts().first,
    );
    final list = <OrderListItem>[];
    for (var i = 0; i < _ordersPerShift; i++) {
      final created = shift.openedAt.add(Duration(minutes: 15 * i + 3));
      final total = 50 + (i * 37 % 500);
      list.add(
        OrderListItem(
          orderId: shiftId * 1000 + i,
          createdAt: created,
          totalKopecks: total * 100,
        ),
      );
    }
    _orders[shiftId] = list;
    return list;
  }

  static Page<T> _paginate<T>(List<T> all, int page) {
    final total = all.length;
    final start = ((page - 1) * _pageSize).clamp(0, total);
    final end = (start + _pageSize).clamp(0, total);
    final items = all.sublist(start, end);
    final hasNext = end < total;
    return Page<T>(
      items: items,
      page: page,
      hasNext: hasNext,
      nextPage: hasNext ? page + 1 : null,
    );
  }

  @override
  Future<Page<ShiftSummary>> getShifts({
    int page = 1,
    String sort = 'opened_at',
    String order = 'desc',
    int? outletId,
  }) async {
    final all = List<ShiftSummary>.from(_getShifts())
      ..sort((a, b) {
        final cmp = switch (sort) {
          'id' => a.id.compareTo(b.id),
          _ => a.openedAt.compareTo(b.openedAt),
        };
        return order == 'asc' ? cmp : -cmp;
      });
    return _paginate(all, page);
  }

  @override
  Future<Page<OrderListItem>> getShiftOrders(
    int shiftId, {
    required String sort,
    required String order,
    int page = 1,
  }) async {
    final all = List<OrderListItem>.from(_getOrders(shiftId))
      ..sort((a, b) {
        final cmp = switch (sort) {
          'total_price' => a.totalKopecks.compareTo(b.totalKopecks),
          _ => a.createdAt.compareTo(b.createdAt),
        };
        return order == 'asc' ? cmp : -cmp;
      });
    return _paginate(all, page);
  }

  @override
  Future<OrderDetail> getOrder(int orderId) async {
    final cached = _orderDetails[orderId];
    if (cached != null) return cached;

    final shiftId = orderId ~/ 1000;
    final idx = orderId % 1000;
    final shift = _getShifts().firstWhere(
      (s) => s.id == shiftId,
      orElse: () => _getShifts().first,
    );
    final created = shift.openedAt.add(Duration(minutes: 15 * idx + 3));
    final itemCount = (idx % 3) + 1;
    final items = <OrderDetailItem>[];
    var total = 0;
    for (var j = 0; j < itemCount; j++) {
      final price = (30 + ((idx + j) * 17 % 200)) * 100;
      final qty = j + 1;
      total += price * qty;
      items.add(
        OrderDetailItem(
          name: 'Товар ${j + 1}',
          quantity: '$qty',
          unitPriceKopecks: price,
          lineTotalKopecks: price * qty,
          variantId: 'v$j',
          options: j == 0
              ? const [
                  OrderDetailOption(
                    name: 'Опція A',
                    priceDeltaKopecks: 500,
                    quantity: 1,
                  ),
                ]
              : const [],
        ),
      );
    }
    final method = idx.isEven ? PaymentMethod.cash : PaymentMethod.card;
    final tendered = method == PaymentMethod.cash ? total + 1000 : total;
    return OrderDetail(
      orderId: orderId,
      shiftId: shiftId,
      status: 'paid',
      createdAt: created,
      totalKopecks: total,
      items: items,
      payment: OrderDetailPayment(
        method: method,
        tenderedKopecks: tendered,
        changeKopecks: tendered - total,
        totalKopecks: total,
      ),
    );
  }

  void addMockOrder(OrderReceipt receipt) {
    final shifts = _getShifts();
    if (shifts.isEmpty) return;
    final activeShift = shifts.last;
    final shiftId = activeShift.id;

    final orderId = int.tryParse(receipt.orderId) ?? 9999;

    final listItem = OrderListItem(
      orderId: orderId,
      createdAt: receipt.issuedAt,
      totalKopecks: receipt.totalKopecks,
    );

    _getOrders(shiftId).add(listItem);

    final detail = OrderDetail(
      orderId: orderId,
      shiftId: shiftId,
      status: 'paid',
      createdAt: receipt.issuedAt,
      totalKopecks: receipt.totalKopecks,
      items: receipt.lines.map((l) {
        return OrderDetailItem(
          name: l.name,
          quantity: l.quantity,
          unitPriceKopecks: l.unitPriceKopecks,
          lineTotalKopecks: l.subtotalKopecks,
          variantId: l.productId,
          options: const [],
        );
      }).toList(),
      payment: OrderDetailPayment(
        method: receipt.method,
        tenderedKopecks: receipt.tenderedKopecks,
        changeKopecks: receipt.changeKopecks,
        totalKopecks: receipt.totalKopecks,
      ),
    );

    _orderDetails[orderId] = detail;
  }
}
