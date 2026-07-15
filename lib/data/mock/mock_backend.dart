import 'dart:async';
import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:prro/core/money.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/api/models/seller_item.dart';

/// In-memory "server" used while the real backend's order/catalog endpoints
/// are not ready. Every method mimics a real round-trip: configurable latency,
/// togglable failure, and POST /orders is idempotent by `idempotencyKey`.
///
/// Prices live here as `int` kopecks — the client never computes totals.
class MockBackend {
  MockBackend._();
  static final MockBackend instance = MockBackend._();

  /// Flip to true (e.g. from a debug button) to make the next requests fail
  /// so error states can be exercised without touching code.
  static bool simulateError = false;

  /// Fake network latency.
  static Duration latency = const Duration(milliseconds: 300);

  /// orderId counter.
  int _nextOrderId = 1001;

  /// idempotencyKey → receipt. Replaying the same key returns the same body.
  final Map<String, OrderReceipt> _receiptsByKey = {};

  // ──────────────────────────────────────────────────────────────────────────
  // Catalog
  // ──────────────────────────────────────────────────────────────────────────

  late final List<_CatalogCategory> _catalog = _seedCatalog();

  Future<List<Item>> getCategories() async {
    await _network();
    return _catalog.map((c) => Category(id: c.id, name: c.name)).toList();
  }

  Future<List<Item>> getProducts(int categoryId) async {
    await _network();
    final cat = _catalog.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => _CatalogCategory(id: -1, name: '', products: const []),
    );
    final out = <Item>[];
    for (final p in cat.products) {
      if (p.variants.isEmpty) continue;
      if (p.variants.length == 1) {
        out.add(_variantToProduct(p, p.variants.single));
      } else {
        out.add(ProductGroup(id: p.id, name: p.name));
      }
    }
    return out;
  }

  Future<List<Item>> getVariants(int productGroupId) async {
    await _network();
    for (final cat in _catalog) {
      for (final p in cat.products) {
        if (p.id == productGroupId) {
          return p.variants.map<Item>((v) => _variantToProduct(p, v)).toList();
        }
      }
    }
    return const [];
  }

  /// Display name keeps the drink name; the size/variant is appended only when
  /// the product has more than one (so "Латте 300 мл", but plain "Еспресо").
  Product _variantToProduct(_CatalogProduct p, _CatalogVariant v) => Product(
    id: v.id.toString(),
    name: p.variants.length > 1 ? '${p.name} ${v.name}' : p.name,
    price: v.priceKopecks / 100.0,
    imageUrl: '',
    quantity: Decimal.one,
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Variant options (stands in for GET /variants/:id/options until it exists)
  // ──────────────────────────────────────────────────────────────────────────

  /// Option groups (Молоко / Сироп ...) for a variant, with the surcharge that
  /// is effective for THIS variant already applied. Empty if the drink has none
  Future<List<OptionGroup>> getVariantOptions(int variantId) async {
    await _network();
    final v = _findVariant(variantId.toString());
    if (v == null) return const [];
    return v.optionGroups.map(_toPublicGroup).toList();
  }

  OptionGroup _toPublicGroup(_OptionGroup g) => OptionGroup(
    id: g.id,
    name: g.name,
    selectionType: g.selectionType,
    isRequired: g.isRequired,
    options: g.options
        .map(
          (o) => DrinkOption(
            id: o.id,
            name: o.name,
            priceDelta: o.priceDeltaKopecks / 100.0,
          ),
        )
        .toList(),
  );

  _CatalogVariant? _findVariant(String id) {
    for (final cat in _catalog) {
      for (final p in cat.products) {
        for (final v in p.variants) {
          if (v.id.toString() == id) return v;
        }
      }
    }
    return null;
  }

  _Option? _optionForId(String variantId, int optionId) {
    final v = _findVariant(variantId);
    if (v == null) return null;
    for (final g in v.optionGroups) {
      for (final o in g.options) {
        if (o.id == optionId) return o;
      }
    }
    return null;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Beans (which coffee was used). Global to the cafe; offered for drinks in
  // the "Кава" category. No surcharge for now.
  // ──────────────────────────────────────────────────────────────────────────

  static const int _coffeeCategoryId = 1;

  late final List<BeanGroup> _beans = _seedBeans();

  /// Bean groups offered for a variant (only coffee drinks), else empty.
  Future<List<BeanGroup>> getVariantBeans(int variantId) async {
    await _network();
    for (final cat in _catalog) {
      for (final p in cat.products) {
        for (final v in p.variants) {
          if (v.id == variantId) {
            return cat.id == _coffeeCategoryId ? _beans : const [];
          }
        }
      }
    }
    return const [];
  }

  Bean? _beanForId(int id) {
    for (final g in _beans) {
      for (final b in g.beans) {
        if (b.id == id) return b;
      }
    }
    return null;
  }

  /// bean id → how many times it was sold. Seeded so "popular" is meaningful
  /// before the first sale. Incremented in [placeOrder].
  /// NOTE: real popularity should come from the backend (shared across
  /// cashiers/devices); this stand-in keeps the demo self-contained.
  final Map<int, int> _beanUsage = {1: 42, 17: 30, 12: 18, 5: 9, 2: 6};

  /// Most-used beans first (only those actually used), capped at [limit].
  Future<List<Bean>> getPopularBeans({int limit = 5}) async {
    await _network();
    final all = [for (final g in _beans) ...g.beans];
    final used = all.where((b) => (_beanUsage[b.id] ?? 0) > 0).toList()
      ..sort(
        (a, b) => (_beanUsage[b.id] ?? 0).compareTo(_beanUsage[a.id] ?? 0),
      );
    return used.take(limit).toList();
  }

  List<BeanGroup> _seedBeans() {
    var beanId = 1;
    Bean bean(String name) => Bean(id: beanId++, name: name);
    return [
      BeanGroup(
        id: 1,
        name: 'Купаж',
        beans: [
          bean('Італьяно бленд (Санторіно)'),
          bean('Кава зі Львова еспресо (Галка)'),
          bean('Індія Черрі'),
          bean('Баунті (Санторіно)'),
        ],
      ),
      BeanGroup(
        id: 2,
        name: 'Ароматизовані',
        beans: [
          bean('Бейліс'),
          bean('Дика вишня (Санторіно)'),
          bean('Ірландський крем (Санторіно)'),
          bean('Тірамісу (Санторіно)'),
          bean('Трюфель (Санторіно)'),
          bean("Фрез'є"),
          bean('Галка ірландський крем'),
        ],
      ),
      BeanGroup(
        id: 3,
        name: 'Арабіка',
        beans: [
          bean('Бразилія FC'),
          bean('Бразилія Сантос (Галка)'),
          bean('Гватемала (Галка)'),
          bean('Гондурас (Галка)'),
          bean('Кенія (Галка)'),
          bean('Колумбія Excelso'),
          bean('Коста-Ріка (Галка)'),
          bean('Куба (Санторіно)'),
          bean('Марагоджип Нікарагуа (Санторіно)'),
          bean('Сальвадор (Галка)'),
          bean('Ефіопія Джимма (Галка)'),
          bean('Ефіопія Джимма (Санторіно)'),
          bean('Ефіопія Сидамо (Санторіно)'),
        ],
      ),
      BeanGroup(
        id: 4,
        name: 'Без кофеїну',
        beans: [
          bean('Без кофеїну Бразилія'),
          bean('Без кофеїну Колумбія'),
        ],
      ),
    ];
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Orders
  // ──────────────────────────────────────────────────────────────────────────

  /// Validates and "charges" the order. Client passes only `{id, quantity}`
  /// per line plus the payment intent; prices and total are computed here.
  Future<OrderReceipt> placeOrder({
    required List<OrderLineDto> items,
    required PaymentDto payment,
    required String idempotencyKey,
  }) async {
    await _network();

    final cached = _receiptsByKey[idempotencyKey];
    if (cached != null) return cached;

    if (items.isEmpty) {
      throw const MockBackendException('Кошик порожній.');
    }

    var totalKopecks = 0;
    final receiptLines = <ReceiptLine>[];
    for (final line in items) {
      final info = _variantInfoForId(line.productId);
      if (info == null) {
        throw MockBackendException(
          'Невідомий товар: ${line.productId}.',
        );
      }
      if (line.quantity <= 0) {
        throw const MockBackendException('Кількість має бути додатньою.');
      }
      // Add the surcharge of each picked option (× portions) to the unit price,
      // and collect their names for the receipt line.
      var optionsKopecks = 0;
      final optionNames = <String>[];
      for (final opt in line.options) {
        final o = _optionForId(line.productId, opt.optionId);
        if (o == null) {
          throw MockBackendException(
            'Опція ${opt.optionId} не призначена цьому напою.',
          );
        }
        final portions = opt.quantity <= 0 ? 1 : opt.quantity;
        optionsKopecks += o.priceDeltaKopecks * portions;
        optionNames.add(portions > 1 ? '${o.name} ×$portions' : o.name);
      }
      // Bean is a free choice; just resolve its name for the receipt.
      final extras = [...optionNames];
      if (line.beanId != null) {
        final bean = _beanForId(line.beanId!);
        if (bean == null) {
          throw MockBackendException('Невідоме зерно: ${line.beanId}.');
        }
        extras.add(bean.name);
        // Track usage so "Часто вживані" reflects real sales.
        _beanUsage[bean.id] = (_beanUsage[bean.id] ?? 0) + line.quantity;
      }
      final unitKopecks = info.priceKopecks + optionsKopecks;
      final subtotal = unitKopecks * line.quantity;
      totalKopecks += subtotal;
      receiptLines.add(
        ReceiptLine(
          productId: line.productId,
          name: extras.isEmpty
              ? info.name
              : '${info.name} · ${extras.join(', ')}',
          quantity: line.quantity.toString(),
          unitPriceKopecks: unitKopecks,
          subtotalKopecks: subtotal,
        ),
      );
    }
    if (totalKopecks <= 0) {
      throw const MockBackendException(
        'Сума замовлення має бути більшою за 0.',
      );
    }

    final int changeKopecks;
    switch (payment.method) {
      case PaymentMethod.cash:
        if (payment.tenderedKopecks < totalKopecks) {
          throw MockBackendException(
            'Недостатньо готівки: внесено '
            '${formatUah(payment.tenderedKopecks)}, '
            'до сплати ${formatUah(totalKopecks)}.',
          );
        }
        changeKopecks = payment.tenderedKopecks - totalKopecks;
      case PaymentMethod.card:
        if (payment.tenderedKopecks != totalKopecks) {
          throw const MockBackendException(
            'Сума оплати карткою має точно дорівнювати сумі чека.',
          );
        }
        changeKopecks = 0;
    }

    final receipt = OrderReceipt(
      orderId: (_nextOrderId++).toString(),
      lines: receiptLines,
      totalKopecks: totalKopecks,
      changeKopecks: changeKopecks,
      tenderedKopecks: payment.tenderedKopecks,
      method: payment.method,
      status: 'completed',
      issuedAt: DateTime.now(),
      storeName: "Кав'ярня Grains World",
      cashierName: 'cashier1',
    );
    _receiptsByKey[idempotencyKey] = receipt;
    log('[MOCK /orders] $idempotencyKey → $receipt');
    return receipt;
  }

  _VariantInfo? _variantInfoForId(String id) {
    for (final cat in _catalog) {
      for (final p in cat.products) {
        for (final v in p.variants) {
          if (v.id.toString() == id) {
            return _VariantInfo(
              name: p.variants.length > 1 ? '${p.name} ${v.name}' : p.name,
              priceKopecks: v.priceKopecks,
            );
          }
        }
      }
    }
    return null;
  }

  Future<void> _network() async {
    await Future<void>.delayed(latency);
    if (simulateError) {
      throw const MockBackendException(
        'Помилка сервера (мок). Спробуйте ще раз.',
      );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Seed data — кав'ярня
  // ──────────────────────────────────────────────────────────────────────────

  List<_CatalogCategory> _seedCatalog() {
    var variantId = 1;
    _CatalogVariant variant(
      String name,
      num uah, {
      List<_OptionGroup> groups = const [],
    }) => _CatalogVariant(
      id: variantId++,
      name: name,
      priceKopecks: uahToKopecks(uah),
      optionGroups: groups,
    );

    // Shared coffee option groups. option ids are global; surcharges here are
    // the values effective for these drinks (the "exception" already applied).
    final milk = _OptionGroup(
      id: 1,
      name: 'Молоко',
      selectionType: OptionSelectionType.single,
      isRequired: false,
      options: [
        _Option(id: 1, name: 'Звичайне', priceDeltaKopecks: 0),
        _Option(id: 2, name: 'Соєве', priceDeltaKopecks: uahToKopecks(25)),
        _Option(
          id: 5,
          name: 'Безлактозне',
          priceDeltaKopecks: uahToKopecks(20),
        ),
      ],
    );
    final syrup = _OptionGroup(
      id: 2,
      name: 'Сироп',
      selectionType: OptionSelectionType.multi,
      isRequired: false,
      options: [
        _Option(id: 3, name: 'Ваніль', priceDeltaKopecks: uahToKopecks(15)),
        _Option(id: 4, name: 'Карамель', priceDeltaKopecks: uahToKopecks(15)),
      ],
    );
    final coffeeOptions = [milk, syrup];

    return [
      _CatalogCategory(
        id: 1,
        name: 'Кава',
        products: [
          _CatalogProduct(
            id: 101,
            name: 'Еспресо',
            variants: [variant('Одинарне', 35)],
          ),
          _CatalogProduct(
            id: 102,
            name: 'Американо',
            variants: [
              variant('250 мл', 45),
              variant('350 мл', 55),
            ],
          ),
          _CatalogProduct(
            id: 103,
            name: 'Капучино',
            variants: [
              variant('250 мл', 60, groups: coffeeOptions),
              variant('350 мл', 70, groups: coffeeOptions),
              variant('450 мл', 85, groups: coffeeOptions),
            ],
          ),
          _CatalogProduct(
            id: 104,
            name: 'Латте',
            variants: [
              variant('300 мл', 70, groups: coffeeOptions),
              variant('400 мл', 85, groups: coffeeOptions),
            ],
          ),
          _CatalogProduct(
            id: 105,
            name: 'Раф',
            variants: [variant('350 мл', 80)],
          ),
        ],
      ),
      _CatalogCategory(
        id: 2,
        name: 'Чай',
        products: [
          _CatalogProduct(
            id: 201,
            name: 'Чорний',
            variants: [
              variant('400 мл', 40),
              variant('700 мл', 60),
            ],
          ),
          _CatalogProduct(
            id: 202,
            name: 'Зелений',
            variants: [
              variant('400 мл', 40),
              variant('700 мл', 60),
            ],
          ),
          _CatalogProduct(
            id: 203,
            name: 'Імбирний',
            variants: [variant('400 мл', 55)],
          ),
        ],
      ),
      _CatalogCategory(
        id: 3,
        name: 'Десерти',
        products: [
          _CatalogProduct(
            id: 301,
            name: 'Чізкейк',
            variants: [variant('Шматок', 95)],
          ),
          _CatalogProduct(
            id: 302,
            name: 'Круасан',
            variants: [variant('Класичний', 55)],
          ),
          _CatalogProduct(
            id: 303,
            name: 'Мафін',
            variants: [
              variant('Шоколадний', 60),
              variant('Чорничний', 65),
            ],
          ),
          _CatalogProduct(
            id: 304,
            name: 'Печиво',
            variants: [variant('Вівсяне', 25)],
          ),
        ],
      ),
    ];
  }
}

// ── DTOs / receipt types now live in `models/order.dart` (shared with the real
// API path). Only the mock-specific exception remains here.

class MockBackendException implements Exception {
  const MockBackendException(this.message);
  final String message;
  @override
  String toString() => message;
}

// ── Internal catalog model (kept private — not exposed to the rest of the app)

class _CatalogCategory {
  _CatalogCategory({
    required this.id,
    required this.name,
    required this.products,
  });
  final int id;
  final String name;
  final List<_CatalogProduct> products;
}

class _CatalogProduct {
  _CatalogProduct({
    required this.id,
    required this.name,
    required this.variants,
  });
  final int id;
  final String name;
  final List<_CatalogVariant> variants;
}

class _CatalogVariant {
  _CatalogVariant({
    required this.id,
    required this.name,
    required this.priceKopecks,
    this.optionGroups = const [],
  });
  final int id;
  final String name;
  final int priceKopecks;
  final List<_OptionGroup> optionGroups;
}

class _OptionGroup {
  _OptionGroup({
    required this.id,
    required this.name,
    required this.selectionType,
    required this.isRequired,
    required this.options,
  });
  final int id;
  final String name;
  final OptionSelectionType selectionType;
  final bool isRequired;
  final List<_Option> options;
}

class _Option {
  _Option({
    required this.id,
    required this.name,
    required this.priceDeltaKopecks,
  });
  final int id;
  final String name;
  final int priceDeltaKopecks;
}

class _VariantInfo {
  const _VariantInfo({required this.name, required this.priceKopecks});
  final String name;
  final int priceKopecks;
}
