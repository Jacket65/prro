import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/data/mock/order_history_repository_mock.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/core/mock/order_request_dto.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/seller/domain/cart.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';

@Environment('mock')
@Singleton(as: OrdersRepositoryI)
class OrdersRepositoryMock implements OrdersRepositoryI {
  OrdersRepositoryMock(this._backend, this._historyRepository);
  final MockBackend _backend;
  final OrderHistoryRepositoryI _historyRepository;

  /// The shared domain cart: the mock walk must exercise exactly the
  /// production cart behaviour (identical to the prod repository — the
  /// duplication this replaces was where they drifted apart).
  final Cart _cart = Cart();

  @override
  List<Product> get products => _cart.products;

  /// Identical to the prod implementation (see
  /// [OrdersRepositoryI.totalPrice]): exact [Decimal] via
  /// [Product.effectiveUnitPrice], converted to kopecks only at the payment
  /// boundary.
  @override
  Decimal get totalPrice => _cart.totalPrice;

  @override
  void addProduct(Product product) => _cart.addProduct(product);

  @override
  void removeProduct(Product product) => _cart.removeProduct(product);

  @override
  void deleteProductLine(Product product) => _cart.deleteProductLine(product);

  @override
  void clearProducts() => _cart.clearProducts();

  /// Kept identical to the prod implementation (see
  /// [OrdersRepositoryI.resetForNewSession]): both forward to the same
  /// [Cart.resetForNewSession], so the mock resets exactly like production.
  @override
  void resetForNewSession() => _cart.resetForNewSession();

  @override
  void updateOptions(
    String lineId,
    List<SelectedOption> options, {
    Bean? bean,
    Decimal? quantity,
  }) => _cart.updateOptions(lineId, options, bean: bean, quantity: quantity);

  @override
  Future<OrderReceipt> placeOrder({
    required PaymentMethod method,
    required int tenderedKopecks,
    required String idempotencyKey,
  }) async {
    try {
      final receipt = await _backend.placeOrder(
        items: _cart.products.map((p) {
          return OrderLineDto(
            productId: p.id,
            // As the client sends it: the raw decimal quantity. Converting
            // through `toDouble().toInt()` used to truncate a 0.250 kg line to
            // 0, which the backend then rejected as a non-positive quantity.
            quantity: p.quantity,
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
