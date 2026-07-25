import 'package:decimal/decimal.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/measure_unit.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';

class MockOrdersRepository implements OrdersRepositoryI {
  MockOrdersRepository({MockBackend? backend})
    : _backend = backend ?? MockBackend.instance;
  final MockBackend _backend;

  final List<Product> _products = [];

  @override
  List<Product> get products => List.unmodifiable(_products);

  @override
  double get totalPrice => _products.fold(
    0,
    (sum, p) => sum + (p.effectiveUnitPrice * p.quantity.toDouble()),
  );

  @override
  void addProduct(Product product) {
    final index = _products.indexWhere((p) => p.lineId == product.lineId);
    if (index != -1) {
      final existing = _products[index];
      _products[index] = existing.copyWith(
        quantity: existing.quantity + unitStep(existing.unit),
      );
    } else {
      _products.add(product);
    }
  }

  @override
  void removeProduct(Product product) {
    final index = _products.indexWhere((p) => p.lineId == product.lineId);
    if (index == -1) return;
    final current = _products[index];
    final step = unitStep(current.unit);
    if (current.quantity > step) {
      _products[index] = current.copyWith(quantity: current.quantity - step);
    } else {
      _products.removeAt(index);
    }
  }

  @override
  void deleteProductLine(Product product) {
    _products.removeWhere((p) => p.lineId == product.lineId);
  }

  @override
  void clearProducts() => _products.clear();

  @override
  void updateOptions(
    String lineId,
    List<SelectedOption> options, {
    Bean? bean,
    Decimal? quantity,
  }) {
    final index = _products.indexWhere((p) => p.lineId == lineId);
    if (index == -1) return;
    final updated = _products[index].copyWith(
      selectedOptions: options,
      selectedBean: bean,
      quantity: quantity,
    );
    if (updated.lineId == lineId) {
      _products[index] = updated;
      return;
    }
    _products.removeAt(index);
    final twin = _products.indexWhere((p) => p.lineId == updated.lineId);
    if (twin != -1) {
      final t = _products[twin];
      _products[twin] = t.copyWith(quantity: t.quantity + updated.quantity);
    } else {
      _products.insert(index, updated);
    }
  }

  @override
  Future<OrderReceipt> placeOrder({
    required PaymentMethod method,
    required int tenderedKopecks,
    required String idempotencyKey,
  }) async {
    final items = _products.map((p) {
      return OrderLineDto(
        productId: p.id,
        quantity: p.quantity.toDouble().toInt(),
        options: p.selectedOptions
            .map(
              (o) =>
                  SelectedOptionDto(optionId: o.optionId, quantity: o.quantity),
            )
            .toList(),
        beanId: p.selectedBean?.id,
      );
    }).toList();

    final payment = PaymentDto(
      method: method,
      tenderedKopecks: tenderedKopecks,
    );

    return _backend.placeOrder(
      items: items,
      payment: payment,
      idempotencyKey: idempotencyKey,
    );
  }
}
