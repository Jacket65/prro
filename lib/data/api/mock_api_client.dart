import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:prro/core/json.dart';
import 'package:prro/core/money.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/models/admin/admin_models.dart';
import 'package:prro/data/api/models/order.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock implementation of ApiClientI that uses the in-memory MockBackend
/// instead of making real HTTP requests.
class MockApiClient implements ApiClientI {
  MockApiClient({
    required this.prefs,
    required this.mockBackend,
  });

  final SharedPreferences prefs;
  final MockBackend mockBackend;
  final StreamController<void> _unauthorized =
      StreamController<void>.broadcast();

  @override
  Stream<void> get onUnauthorized => _unauthorized.stream;

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      // ── Admin panel endpoints (outlet-scoped) ──
      if (path.contains('/retail-outlets')) {
        final outletId = _extractOutletId(path);
        if (path.contains('/users') && outletId != null) {
          final users = await mockBackend.getAdminUsers(outletId);
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': users},
            statusCode: 200,
          );
        } else if (path.contains('/categories') && outletId != null) {
          final categories = await mockBackend.getAdminCategories(outletId);
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': categories},
            statusCode: 200,
          );
        } else if (path.contains('/ingredients') && outletId != null) {
          final ingredients = await mockBackend.getAdminIngredients(outletId);
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': ingredients},
            statusCode: 200,
          );
        }
        // Bare `/retail-outlets/` → all outlets.
        final outlets = await mockBackend.getAdminOutlets();
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': outlets},
          statusCode: 200,
        );
      }

      if (path.contains('/measure-units')) {
        final units = await mockBackend.getMeasureUnits();
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': units},
          statusCode: 200,
        );
      } else if (path.contains('/categories')) {
        final categories = await mockBackend.getCategories();
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': categories},
          statusCode: 200,
        );
      } else if (path.contains('/products')) {
        // Extract categoryId from path if present
        final categoryId = _extractCategoryId(path);
        if (categoryId != null) {
          final products = await mockBackend.getProducts(categoryId);
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': products},
            statusCode: 200,
          );
        } else {
          // Search products
          final query = queryParameters?['q'] as String? ?? '';
          final categoryIdParam = queryParameters?['category_id'] as int?;
          final products = await mockBackend.searchProducts(
            query: query,
            categoryId: categoryIdParam,
          );
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': products},
            statusCode: 200,
          );
        }
      } else if (path.contains('/variants')) {
        // Get variants for a product
        final productId = _extractProductId(path);
        if (productId != null) {
          final variants = await mockBackend.getVariants(productId);
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': variants},
            statusCode: 200,
          );
        }
        // Get options for a variant
        final variantId = _extractVariantId(path);
        if (variantId != null) {
          final options = await mockBackend.getVariantOptions(
            variantId,
          );
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': options},
            statusCode: 200,
          );
        }
      } else if (path.contains('/beans')) {
        // Mock beans endpoint
        final popularBeans = await mockBackend.getPopularBeans();
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': popularBeans},
          statusCode: 200,
        );
      } else if (path.contains('/ingredients')) {
        // Return empty list for ingredients in mock mode
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': const <List<dynamic>>[]},
          statusCode: 200,
        );
      } else if (path.contains('/retail-outlets')) {
        // Mock retail outlets endpoints
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': const <List<dynamic>>[]},
          statusCode: 200,
        );
      }

      // Default fallback
      log('[MOCK API] Unhandled GET path: $path');
      return Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        data: {'data': const <List<dynamic>>[]},
        statusCode: 200,
      );
    } catch (e) {
      log('[MOCK API] Error in GET $path: $e');
      throw DioException(
        requestOptions: RequestOptions(path: path),
        message: e.toString(),
      );
    }
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
  }) async {
    try {
      if (path.contains('/orders')) {
        final orderData = data as Map<String, dynamic>?;
        if (orderData != null) {
          final items =
              (orderData['items'] as List<dynamic>?)?.map((item) {
                final itemMap = item as Map<String, dynamic>;
                return OrderLineDto(
                  productId: itemMap['product_id'] as String,
                  quantity: itemMap['quantity'] as int,
                  options:
                      (itemMap['options'] as List<dynamic>?)?.map(
                        (opt) {
                          final optMap = opt as Map<String, dynamic>;
                          return SelectedOptionDto(
                            optionId: optMap['option_id'] as int,
                            quantity: optMap['quantity'] as int? ?? 1,
                          );
                        },
                      ).toList() ??
                      <SelectedOptionDto>[],
                  beanId: itemMap['bean_id'] as int?,
                );
              }).toList() ??
              <OrderLineDto>[];

          final paymentData = orderData['payment'] as Map<String, dynamic>?;
          final paymentMethod = paymentData?['method'] as String? ?? 'cash';
          final tenderedKopecks = paymentData?['tendered'] as int? ?? 0;

          final receipt = await mockBackend.placeOrder(
            items: items,
            payment: PaymentDto(
              method: paymentMethod == 'card'
                  ? PaymentMethod.card
                  : PaymentMethod.cash,
              tenderedKopecks: tenderedKopecks,
            ),
            idempotencyKey: idempotencyKey ?? '',
          );

          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: <String, dynamic>{
              'order_id': receipt.orderId,
              'items': receipt.lines
                  .map(
                    (line) => <String, dynamic>{
                      'variant_id': line.productId,
                      'name': line.name,
                      'quantity': line.quantity,
                      'unit_price': (line.unitPriceKopecks / 100).toString(),
                      'line_total': (line.subtotalKopecks / 100).toString(),
                    },
                  )
                  .toList(),
              'total_price': (receipt.totalKopecks / 100).toString(),
              'payment': <String, String>{
                'method': receipt.method.wire,
                'tendered': (receipt.tenderedKopecks / 100).toString(),
                'change': (receipt.changeKopecks / 100).toString(),
              },
              'status': receipt.status,
              'created_at': receipt.issuedAt.toIso8601String(),
            },
            statusCode: 201,
          );
        }
      } else if (path.contains('/auth/login')) {
        // Mock login - always successful
        final loginData = data as Map<String, dynamic>?;
        log('[MOCK API] Login attempt with: ${loginData?['username']}');

        // Store mock tokens
        await prefs.setString(
          'auth_token',
          'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        );
        await prefs.setString('refresh_token', 'mock_refresh_token');
        await prefs.setBool('isLogged', true);
        await prefs.setInt('outlet_id', 1); // Set a default outlet for mock

        return Response(
          requestOptions: RequestOptions(path: path),
          data: {
            'access_token': prefs.getString('auth_token'),
            'refresh_token': prefs.getString('refresh_token'),
          },
          statusCode: 200,
        );
      } else if (path.contains('/auth/refresh')) {
        // Mock token refresh
        log('[MOCK API] Token refresh');

        // Generate new mock token
        final newToken =
            'mock_token_refreshed_${DateTime.now().millisecondsSinceEpoch}';
        await prefs.setString('auth_token', newToken);

        return Response(
          requestOptions: RequestOptions(path: path),
          headers: Headers.fromMap({
            'authorization': ['Bearer $newToken'],
          }),
          statusCode: 204,
        );
      } else if (path.contains('/retail-outlets') &&
          path.contains('/categories')) {
        final outletId = _extractOutletId(path);
        final name = _nameOf(data);
        final category = await mockBackend.createAdminCategory(
          outletId: outletId!,
          name: name,
        );
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': category},
          statusCode: 201,
        );
      } else if (path.contains('/categories') && path.contains('/products')) {
        final categoryId = _extractIdAfter(path, 'categories');
        final product = await mockBackend.createAdminProduct(
          categoryId: categoryId!,
          name: _nameOf(data),
        );
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': product},
          statusCode: 201,
        );
      } else if (path.contains('/products') && path.contains('/variants')) {
        final productId = _extractIdAfter(path, 'products');
        final map = data as Map<String, dynamic>?;
        final priceKopecks = _priceKopecks(map?['price']);
        final ingredients = _ingredientsOf(map?['ingredients']);
        final variant = await mockBackend.createAdminVariant(
          productId: productId!,
          name: _nameOf(data),
          priceKopecks: priceKopecks,
          ingredients: ingredients,
        );
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': variant},
          statusCode: 201,
        );
      }

      log('[MOCK API] Unhandled POST path: $path');
      return Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        data: <String, dynamic>{},
        statusCode: 200,
      );
    } catch (e) {
      log('[MOCK API] Error in POST $path: $e');
      throw DioException(
        requestOptions: RequestOptions(path: path),
        message: e.toString(),
      );
    }
  }

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
  }) async {
    try {
      if (path.contains('/categories/')) {
        final id = _extractIdAfter(path, 'categories');
        final category = await mockBackend.updateAdminCategory(
          id: id!,
          name: _nameOf(data),
        );
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': category},
          statusCode: 200,
        );
      } else if (path.contains('/products/')) {
        final id = _extractIdAfter(path, 'products');
        final product = await mockBackend.updateAdminProduct(
          id: id!,
          name: _nameOf(data),
        );
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': product},
          statusCode: 200,
        );
      } else if (path.contains('/variants/')) {
        final id = _extractIdAfter(path, 'variants');
        final map = data as Map<String, dynamic>?;
        final variant = await mockBackend.updateAdminVariant(
          id: id!,
          name: _nameOf(data),
          priceKopecks: _priceKopecks(map?['price']),
        );
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': variant},
          statusCode: 200,
        );
      }
      log('[MOCK API] PATCH $path with data: $data');
      return Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        data: data,
        statusCode: 200,
      );
    } catch (e) {
      log('[MOCK API] Error in PATCH $path: $e');
      throw DioException(
        requestOptions: RequestOptions(path: path),
        message: e.toString(),
      );
    }
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
  }) async {
    try {
      if (path.contains('/variants') && path.contains('/recipe')) {
        final variantId = _extractIdAfter(path, 'variants');
        final map = data as Map<String, dynamic>?;
        final ingredients = _ingredientsOf(map?['ingredients']);
        await mockBackend.replaceAdminRecipe(
          variantId: variantId!,
          ingredients: ingredients,
        );
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': ingredients},
          statusCode: 200,
        );
      }
      log('[MOCK API] PUT $path with data: $data');
      return Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        data: data ?? <String, dynamic>{},
        statusCode: 200,
      );
    } catch (e) {
      log('[MOCK API] Error in PUT $path: $e');
      throw DioException(
        requestOptions: RequestOptions(path: path),
        message: e.toString(),
      );
    }
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
  }) async {
    try {
      if (path.contains('/categories/')) {
        final id = _extractIdAfter(path, 'categories');
        await mockBackend.deleteAdminCategory(id: id!);
      } else if (path.contains('/products/')) {
        final id = _extractIdAfter(path, 'products');
        await mockBackend.deleteAdminProduct(id: id!);
      } else if (path.contains('/variants/')) {
        final id = _extractIdAfter(path, 'variants');
        await mockBackend.deleteAdminVariant(id: id!);
      }
      log('[MOCK API] DELETE $path');
      return Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        statusCode: 204,
      );
    } catch (e) {
      log('[MOCK API] Error in DELETE $path: $e');
      throw DioException(
        requestOptions: RequestOptions(path: path),
        message: e.toString(),
      );
    }
  }

  int? _extractCategoryId(String path) {
    final match = RegExp(r'/categories/(\d+)/products').firstMatch(path);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return null;
  }

  int? _extractOutletId(String path) {
    final match = RegExp(r'/retail-outlets/(\d+)').firstMatch(path);
    return match == null ? null : int.parse(match.group(1)!);
  }

  /// Extracts the `{id}` that immediately follows `/<segment>/` in a path, e.g.
  /// `/categories/12` → `12`, `/products/7/variants` → `7`.
  int? _extractIdAfter(String path, String segment) {
    final match = RegExp('/$segment/(\\d+)').firstMatch(path);
    return match == null ? null : int.parse(match.group(1)!);
  }

  String _nameOf(dynamic data) =>
      (data as Map<String, dynamic>?)?['name']?.toString().trim() ?? '';

  int _priceKopecks(dynamic raw) => raw == null
      ? 0
      : uahToKopecks(
          raw is num ? raw.toDouble() : double.tryParse(raw.toString()) ?? 0,
        );

  List<RecipeIngredient> _ingredientsOf(dynamic raw) {
    final list = raw;
    if (list is! List) return const [];
    return [
      for (final e in list)
        if (e is Map<String, dynamic>)
          RecipeIngredient(
            ingredientId: parseInt(e['ingredient_id']),
            name: parseString(e['name']),
            quantity: parseDouble(e['quantity']),
          ),
    ];
  }

  int? _extractProductId(String path) {
    final match = RegExp(r'/products/(\d+)/variants').firstMatch(path);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return null;
  }

  int? _extractVariantId(String path) {
    final match = RegExp(r'/variants/(\d+)/options').firstMatch(path);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return null;
  }
}
