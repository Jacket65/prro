import 'package:decimal/decimal.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart'
    show OrdersRepositoryI;

/// The seller's shopping cart — one implementation shared by the prod and the
/// mock order repositories.
///
/// Lives in `domain/` because it is business state, not transport: both
/// [OrdersRepositoryI] implementations must hold an identical cart so the mock
/// walk exercises exactly the production behaviour. Only the wire calls
/// (`placeOrder` / `confirmOrder`) stay per-repository.
///
/// Lines are keyed by `lineId`: the same variant with different options is a
/// separate line, the same variant+options stacks (+1 unit step).
class Cart {
  final List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  /// Client-side approximation used only for the live "разом" display.
  /// The authoritative total comes from the order's receipt. Includes the
  /// surcharge of each line's selected options via [Product.effectiveUnitPrice]
  /// all in exact [Decimal] — the cart is never priced through a `double`.
  Decimal get totalPrice => _products.fold(
    Decimal.zero,
    (sum, p) => sum + p.effectiveUnitPrice * p.quantity,
  );

  void addProduct(Product product) {
    // Lines are keyed by lineId: the same variant with different options is a
    // separate line, the same variant+options stacks (+1 unit step).
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

  void removeProduct(Product product) {
    final index = _products.indexWhere((p) => p.lineId == product.lineId);
    if (index == -1) return;
    final current = _products[index];
    final step = unitStep(current.unit);
    // Drop a step; at (or below) one step the line is removed.
    if (current.quantity > step) {
      _products[index] = current.copyWith(quantity: current.quantity - step);
    } else {
      _products.removeAt(index);
    }
  }

  void deleteProductLine(Product product) {
    // Видаляємо всю позицію за її унікальним lineId за один раз
    _products.removeWhere((p) => p.lineId == product.lineId);
  }

  void clearProducts() => _products.clear();

  /// Drops the whole cart. The repository singleton lives across logins, so
  /// this runs at every login and every session end (logout, expiry, admin
  /// re-login): the *when* is the owner's concern; the clear itself is this
  /// single method both owners share.
  void resetForNewSession() => _products.clear();

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
    // Options unchanged → just replace in place.
    if (updated.lineId == lineId) {
      _products[index] = updated;
      return;
    }
    // Options changed → new line identity. Drop the old line and merge into an
    // identical existing line if one exists, otherwise keep it in place.
    _products.removeAt(index);
    final twin = _products.indexWhere((p) => p.lineId == updated.lineId);
    if (twin != -1) {
      final t = _products[twin];
      _products[twin] = t.copyWith(quantity: t.quantity + updated.quantity);
    } else {
      _products.insert(index, updated);
    }
  }
}
