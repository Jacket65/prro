import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/domain/bean.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/domain/drink_option.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/utils/envelope.dart';
import 'package:prro/features/seller/domain/repositories/items_repository_i.dart';

@Environment('prod')
@Singleton(as: ItemsRepositoryI)
class ItemsRepository implements ItemsRepositoryI {
  ItemsRepository({required this._apiClient, required this._outlets});
  final ApiClientI _apiClient;
  final OutletSession _outlets;

  /// Session cache of `GET /variants/:id/options` keyed by variant id, plus the
  /// in-flight request so two near-simultaneous callers (options + beans) share
  /// a single network round-trip instead of firing two identical GETs.
  final Map<int, List<OptionGroup>> _optionsCache = {};
  final Map<int, Future<List<OptionGroup>>> _optionsInFlight = {};

  @override
  Future<List<Item>> getCategories() async {
    try {
      final outletId = _outlets.idOrNull();
      if (outletId == null) {
        log('ItemsRepository.getCategories: outlet_id is not set');
        return [];
      }
      final response = await _apiClient.get(
        '/retail-outlets/$outletId/categories',
      );
      return unwrapList(response.data, Category.fromJson);
    } on Object catch (e, stackTrace) {
      log('Error in getCategories: $e', stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<Item>> getProducts(int categoryId) async {
    try {
      final response = await _apiClient.get('/categories/$categoryId/products');
      return _flattenProducts(unwrapList(response.data, ProductGroup.fromJson));
    } on Object catch (e, stackTrace) {
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
    final outletId = _outlets.idOrNull();
    if (outletId == null) return const [];
    // Errors (incl. cancellation) propagate so the caller can tell a superseded
    // search from a real failure.
    final response = await _apiClient.get(
      '/retail-outlets/$outletId/products',
      queryParameters: {
        if (query.isNotEmpty) 'q': query,
        'category_id': categoryId,
      },
      cancelToken: cancelToken,
    );
    return _flattenProducts(unwrapList(response.data, ProductGroup.fromJson));
  }

  /// Products arrive with their variants inline (single request, no N+1).
  /// Flatten for the catalog: a product with exactly one variant becomes a
  /// directly-orderable tile, more than one keeps the picker, and zero variants
  /// is hidden (unsellable).
  List<Item> _flattenProducts(List<ProductGroup> groups) {
    final out = <Item>[];
    for (final group in groups) {
      if (group.variants.isEmpty) continue;
      out.add(group.variants.length == 1 ? group.variants.first : group);
    }
    return out;
  }

  @override
  Future<List<MeasureUnit>> getMeasureUnits() async {
    try {
      final response = await _apiClient.get('/measure-units');
      return unwrapList(response.data, MeasureUnit.fromJson);
    } on Object catch (e, stackTrace) {
      log('Error in getMeasureUnits: $e', stackTrace: stackTrace);
      return [];
    }
  }

  /// The option group whose name marks "which coffee bean was used". Beans are
  /// modelled on the wire as an ordinary option group; we single it out by name
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
        final groups = unwrapList(response.data, OptionGroup.fromJson);
        _optionsCache[variantId] = groups;
        return groups;
      } on Object catch (e, stackTrace) {
        // Don't cache failures — let the next selection retry.
        log(
          'Error in getVariantOptions($variantId): $e',
          stackTrace: stackTrace,
        );
        return const <OptionGroup>[];
      } finally {
        await _optionsInFlight.remove(variantId);
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
}
