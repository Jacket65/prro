import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/config/env.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/utils/json.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton(as: OrdersRepositoryI)
@Environment('prod')
class OrdersRepositoryImpl implements OrdersRepositoryI {
  OrdersRepositoryImpl({required this._apiClient, required this._prefs});
  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  final List<Product> _products = [];

  @override
  List<Product> get products => List.unmodifiable(_products);

  /// Client-side approximation used only for the live "разом" display.
  /// The authoritative total comes from [placeOrder]'s receipt. Includes the
  /// surcharge of each line's selected options via [Product.effectiveUnitPrice]
  @override
  double get totalPrice => _products.fold(
    0,
    (sum, p) => sum + (p.effectiveUnitPrice * p.quantity.toDouble()),
  );

  @override
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

  @override
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

  @override
  void deleteProductLine(Product product) {
    // Видаляємо всю позицію за її унікальним lineId за один раз
    _products.removeWhere((p) => p.lineId == product.lineId);
  }

  @override
  void clearProducts() => _products.clear();

  /// See [OrdersRepositoryI.resetForNewSession]. The cart is the only
  /// session-scoped state this singleton holds, so the reset is the clear —
  /// the point is *when* it runs (every login and every session end), not a
  /// second, subtly different clear path that can drift from this one.
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

  /// `POST /orders` and `POST /orders/{id}/confirm` answer with the same receipt
  /// envelope, so the parse is shared. The store/cashier names are local-only
  /// fields the backend does not return.
  OrderReceipt _receipt(Response<dynamic> response) => OrderReceipt.fromJson(
    // A body with no object payload is a protocol violation: fail rather than
    // invent an empty receipt.
    unwrapPayload(response.data)!,
    storeName: Env.storeName,
    cashierName: _prefs.getString('username') ?? '',
  );

  @override
  Future<OrderReceipt> placeOrder({
    required PaymentMethod method,
    required int tenderedKopecks,
    required String idempotencyKey,
  }) async {
    final outletId = requireOutletId(_prefs);
    // Backend expects quantities/amounts as decimal STRINGS. The selected bean
    // is just another option, so it folds into the line's `options` array.
    final productsJson = _products.map((p) {
      final options = <Map<String, dynamic>>[
        for (final o in p.selectedOptions)
          {'option_id': o.optionId, 'quantity': o.quantity},
        if (p.selectedBean != null)
          {'option_id': p.selectedBean!.id, 'quantity': 1},
      ];
      return {
        'id': int.tryParse(p.id) ?? p.id,
        // Decimal string at the unit's precision ("0.250" for kg, "2" for pcs).
        'quantity': p.quantity.toStringAsFixed(unitScale(p.unit)),
        if (options.isNotEmpty) 'options': options,
      };
    }).toList();

    final body = {
      // `type` is required by the backend (`oneof=cash card`); `terminal`
      // travels as `card` and produces a `pending` order that the terminal
      // flow confirms afterwards.
      'type': method.wire,
      'products': productsJson,
      'payment': {
        'method': method.wire,
        'amount': formatAmount(tenderedKopecks),
      },
    };

    try {
      final response = await _apiClient.post(
        '/retail-outlets/$outletId/orders',
        data: body,
        idempotencyKey: idempotencyKey,
      );
      return _receipt(response);
    } on DioException catch (e) {
      // The seller's shift can be closed from another device while the screen
      // is still open: the backend answers 404 (no open shift) instead of 409.
      // Report the fact; `PayOrderUseCase` turns it into the wording the seller
      // sees, since a message thrown from here never reaches the UI.
      if (e.response?.statusCode == 404) {
        throw const ShiftClosedException();
      }
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<OrderReceipt> confirmOrder(int orderId) async {
    try {
      final response = await _apiClient.post('/orders/$orderId/confirm');
      return _receipt(response);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
