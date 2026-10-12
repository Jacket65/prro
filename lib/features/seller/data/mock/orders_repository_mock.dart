import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/data/mock/order_history_repository_mock.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/core/mock/order_request_dto.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';

@Environment('mock')
@Singleton(as: OrdersRepositoryI)
class OrdersRepositoryMock implements OrdersRepositoryI {
  OrdersRepositoryMock(this._backend, this._historyRepository);
  final MockBackend _backend;
  final OrderHistoryRepositoryI _historyRepository;

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

  /// Kept identical to the prod implementation (see
  /// [OrdersRepositoryI.resetForNewSession]): the cart is the whole of the
  /// session-scoped state, so the mock must reset exactly like production.
  @override
  void resetForNewSession() => _products.clear();

  @override
  void updateOptions(
    String lineId,
    List<SelectedOption> options, {
    Bean? bean,
    Decimal? quantity,
  }) {
    final index = _products.indexWhere((p) => p.lineId == lineId);
    if (index == -1) return;
    // Generated `copyWith` clears a nullable field when it is passed explicitly
    // null, so only pass what the caller set: `bean: null` drops the line's
    // bean, and `quantity` (non-nullable) can only be replaced, never cleared.
    final line = _products[index];
    final updated = quantity == null
        ? line.copyWith(selectedOptions: options, selectedBean: bean)
        : line.copyWith(
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
    try {
      final receipt = await _backend.placeOrder(
        items: _products.map((p) {
          return OrderLineDto(
            productId: p.id,
            quantity: p.quantity.toDouble().toInt(),
            options: [
              ...p.selectedOptions.map(
                (o) => SelectedOptionDto(
                  optionId: o.optionId,
                  quantity: o.quantity,
                ),
              ),
              if (p.selectedBean != null)
                SelectedOptionDto(optionId: p.selectedBean!.id),
            ],
          );
        }).toList(),
        payment: PaymentDto(method: method, tenderedKopecks: tenderedKopecks),
        idempotencyKey: idempotencyKey,
      );
      // The mock history is in-process, so a placed order is appended to it
      // directly; prod history is read back from the backend on refresh.
      final history = _historyRepository;
      if (history is OrderHistoryRepositoryMock) {
        history.addMockOrder(receipt);
      }
      return receipt;
    } on MockBackendException catch (e) {
      throw ApiException(e.message);
    }
  }

  @override
  Future<OrderReceipt> confirmOrder(int orderId) async {
    try {
      return await _backend.confirmOrder(orderId);
    } on MockBackendException catch (e) {
      throw ApiException(e.message);
    }
  }
}
