import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:prro/config/env.dart';
import 'package:prro/core/money.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/data/repositories/orders_repository/orders_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersRepository implements OrdersRepositoryI {
  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  final List<Product> _products = [];

  OrdersRepository({
    required ApiClientI apiClient,
    required SharedPreferences prefs,
  }) : _apiClient = apiClient,
       _prefs = prefs;

  @override
  List<Product> get products => List.unmodifiable(_products);

  /// Client-side approximation used only for the live "разом" display.
  /// The authoritative total comes from [placeOrder]'s receipt. Includes the
  /// surcharge of each line's selected options via [Product.effectiveUnitPrice].
  @override
  double get totalPrice => _products.fold(
    0.0,
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

  @override
  Future<OrderReceipt> placeOrder({
    required PaymentMethod method,
    required int tenderedKopecks,
    required String idempotencyKey,
  }) async {
    final outletId = _prefs.getInt('outlet_id');
    if (outletId == null) {
      throw const ApiException('Точку продажу не визначено. Увійдіть знову.');
    }

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
      final raw = response.data;
      final data = raw is Map && raw['data'] is Map
          ? (raw['data'] as Map).cast<String, dynamic>()
          : (raw as Map).cast<String, dynamic>();
      return OrderReceipt.fromJson(
        data,
        storeName: Env.storeName,
        cashierName: _prefs.getString('username') ?? '',
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
