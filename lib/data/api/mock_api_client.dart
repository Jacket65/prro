import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:prro/data/api/api_client_i.dart';
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

  int? _extractCategoryId(String path) {
    final match = RegExp(r'/categories/(\d+)/products').firstMatch(path);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return null;
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
