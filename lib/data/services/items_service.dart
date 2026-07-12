import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/models/bean.dart';
import 'package:prro/data/api/models/drink_option.dart';
import 'package:prro/data/api/models/ingredient.dart';
import 'package:prro/data/api/models/measure_unit.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/items_repository/items_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsService implements ItemsServiceI {
  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  /// Session cache of `GET /variants/:id/options` keyed by variant id, plus the
  /// in-flight request so two near-simultaneous callers (options + beans) share
  /// a single network round-trip instead of firing two identical GETs.
  final Map<int, List<OptionGroup>> _optionsCache = {};
  final Map<int, Future<List<OptionGroup>>> _optionsInFlight = {};

  ItemsService({
    required ApiClientI apiClient,
    required SharedPreferences prefs,
  }) : _apiClient = apiClient,
       _prefs = prefs;

  int? _outletId() => _prefs.getInt('outlet_id');

  @override
  Future<List<Item>> getCategories() async {
    try {
      final outletId = _outletId();
      if (outletId == null) {
        log('ItemsService.getCategories: outlet_id is not set');
        return [];
      }
      final response = await _apiClient.get(
        '/retail-outlets/$outletId/categories',
      );
      final data = _extractList(response.data);
      return data.map<Item>((json) => Category.fromJson(json)).toList();
    } catch (e, stackTrace) {
      log('Error in getCategories: $e', stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<Item>> getProducts(int categoryId) async {
    try {
      final response = await _apiClient.get('/categories/$categoryId/products');
      return _flattenProducts(_extractList(response.data));
    } catch (e, stackTrace) {
      log('Error in getProducts: $e', stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<Item>> searchProducts({
    required String query,
    int? categoryId,
    CancelToken? cancelToken,
  }) async {
    final outletId = _outletId();
    if (outletId == null) return const [];
    // Errors (incl. cancellation) propagate so the caller can tell a superseded
    // search from a real failure.
    final response = await _apiClient.get(
      '/retail-outlets/$outletId/products',
      queryParameters: {
        if (query.isNotEmpty) 'q': query,
        'category_id': ?categoryId,
      },
      cancelToken: cancelToken,
    );
    return _flattenProducts(_extractList(response.data));
  }

  /// Products arrive with their variants inline (single request, no N+1).
  /// Flatten for the catalog: a product with exactly one variant becomes a
  /// directly-orderable tile, more than one keeps the picker, and zero variants
  /// is hidden (unsellable).
  List<Item> _flattenProducts(List<dynamic> data) {
    final out = <Item>[];
    for (final json in data.whereType<Map>()) {
      final group = ProductGroup.fromJson(json.cast<String, dynamic>());
      if (group.variants.isEmpty) continue;
      out.add(group.variants.length == 1 ? group.variants.first : group);
    }
    return out;
  }

  /// Variants of a single product. The menu no longer needs this (variants come
  /// inline with [getProducts]); kept because the endpoint still exists.
  @override
  Future<List<Item>> getVariants(int productId) async {
    try {
      final response = await _apiClient.get('/products/$productId/variants');
      final data = _extractList(response.data);
      // Variants are the leaves — they have a price/unit and go into the cart.
      return data
          .whereType<Map>()
          .map<Item>((json) => Product.fromJson(json.cast<String, dynamic>()))
          .toList();
    } catch (e, stackTrace) {
      log('Error in getVariants: $e', stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<Ingredient>> getIngredients() async {
    try {
      final outletId = _outletId();
      if (outletId == null) {
        log('ItemsService.getIngredients: outlet_id is not set');
        return [];
      }
      final response = await _apiClient.get(
        '/retail-outlets/$outletId/ingredients',
      );
      final data = _extractList(response.data);
      return data
          .map<Ingredient>(
            (json) => Ingredient.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e, stackTrace) {
      log('Error in getIngredients: $e', stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<MeasureUnit>> getMeasureUnits() async {
    try {
      final response = await _apiClient.get('/measure-units');
      final data = _extractList(response.data);
      return data
          .map<MeasureUnit>(
            (json) => MeasureUnit.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e, stackTrace) {
      log('Error in getMeasureUnits: $e', stackTrace: stackTrace);
      return [];
    }
  }

  /// The option group whose name marks "which coffee bean was used". Beans are
  /// modelled on the wire as an ordinary option group; we single it out by name.
  static const _beansGroupName = 'зерна';

  /// `GET /variants/:id/options` → every option group of the variant. Beans are
  /// one of these groups; callers filter by [_isBeansGroup].
  ///
  /// Cached per variant for the session and de-duplicated while in flight, so
  /// the options + beans callers (and repeat selections of the same drink)
  /// trigger exactly one network request.
  Future<List<OptionGroup>> _fetchOptionGroups(int variantId) {
    final cached = _optionsCache[variantId];
    if (cached != null) return Future.value(cached);

    return _optionsInFlight.putIfAbsent(variantId, () async {
      try {
        final response = await _apiClient.get('/variants/$variantId/options');
        final data = _extractList(response.data);
        final groups = data
            .whereType<Map>()
            .map((m) => OptionGroup.fromJson(m.cast<String, dynamic>()))
            .toList();
        _optionsCache[variantId] = groups;
        return groups;
      } catch (e, stackTrace) {
        // Don't cache failures — let the next selection retry.
        log(
          'Error in getVariantOptions($variantId): $e',
          stackTrace: stackTrace,
        );
        return const <OptionGroup>[];
      } finally {
        _optionsInFlight.remove(variantId);
      }
    });
  }

  bool _isBeansGroup(OptionGroup g) =>
      g.name.trim().toLowerCase() == _beansGroupName;

  @override
  Future<List<OptionGroup>> getVariantOptions(int variantId) async {
    final groups = await _fetchOptionGroups(variantId);
    // The beans group is surfaced separately via getVariantBeans.
    return groups.where((g) => !_isBeansGroup(g)).toList();
  }

  @override
  Future<List<BeanGroup>> getVariantBeans(int variantId) async {
    final groups = await _fetchOptionGroups(variantId);
    // The "Зерна" option group becomes one bean group; each option is a bean
    // (its option_id is the id we send back when placing the order).
    return groups.where(_isBeansGroup).map((g) {
      // Default bean(s) first so the catalog-add default (first bean) honours
      // is_default; order within each group is otherwise preserved.
      final ordered = [
        ...g.options.where((o) => o.isDefault),
        ...g.options.where((o) => !o.isDefault),
      ];
      return BeanGroup(
        id: g.id,
        name: g.name,
        beans: ordered.map((o) => Bean(id: o.id, name: o.name)).toList(),
      );
    }).toList();
  }

  @override
  Future<List<Bean>> getPopularBeans({int limit = 5}) async {
    // The backend does not rank beans by sales yet. There is also no
    // outlet-wide beans endpoint (beans live under a variant), so the "Часто
    // вживані" shortcut stays empty; the full bean list is shown via the
    // variant's bean group instead.
    return const [];
  }

  @override
  Future<List<Item>> getItemsCategory() => getCategories();

  @override
  Future<List<Item>> fetchItems() => getCategories();

  @override
  Future<List<Item>> fetchItemsForCategory(Category category) {
    return Future.value(category.items);
  }

  List<dynamic> _extractList(dynamic body) {
    if (body is Map && body['data'] is List) {
      return body['data'] as List<dynamic>;
    }
    return const <dynamic>[];
  }
}
