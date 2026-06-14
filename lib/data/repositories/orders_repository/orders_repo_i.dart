import 'package:decimal/decimal.dart';
import 'package:prro/data/api/models/models.dart';

abstract interface class OrdersRepositoryI {
  List<Product> get products;
  double get totalPrice;

  /// Adds [product] (or bumps an identical line by one unit step).
  void addProduct(Product product);

  /// Drops one unit step from the matching line (removing it at the minimum).
  void removeProduct(Product product);
  void clearProducts();

  /// Replaces the selected options, bean and (if given) [quantity] of the cart
  /// line identified by [lineId]. Changing options/bean changes the line
  /// identity; if that matches another existing line the two are merged
  /// (quantities summed).
  void updateOptions(
    String lineId,
    List<SelectedOption> options, {
    Bean? bean,
    Decimal? quantity,
  });

  /// Sends the current cart to the backend (`POST /retail-outlets/{id}/orders`).
  /// Prices and totals are computed server-side; the receipt is authoritative.
  ///
  /// Re-calling with the same [idempotencyKey] is safe and returns the same
  /// receipt (no duplicate order is created).
  Future<OrderReceipt> placeOrder({
    required PaymentMethod method,
    required int tenderedKopecks,
    required String idempotencyKey,
  });
}
