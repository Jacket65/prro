import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/core/mock/order_request_dto.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/utils/json.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/admin/data/models/admin_models.dart';

/// Mock implementation of ApiClientI that uses the in-memory MockBackend
/// instead of making real HTTP requests.
///
/// This class is a transport only — it returns tokens in responses but never
/// persists them. The repository owns session persistence.
///
/// The `timeout` parameter of [ApiClientI] is accepted and deliberately
/// ignored: there is no network to bound, and the fake latency already lives
/// in [MockBackend.latency]. Only the real transport translates it into dio
/// options.
class MockApiClient implements ApiClientI {
  MockApiClient({required this.mockBackend});

  final MockBackend mockBackend;
  final StreamController<String?> _unauthorized =
      StreamController<String?>.broadcast();

  Map<String, dynamic>? _lastUser;

  /// The mock's accounts, `login → password` — the plaintext stand-in for what
  /// the real backend hashes.
  ///
  /// The password is checked exactly, because a login screen cannot be
  /// exercised against a checker that accepts any non-empty string: a wrong
  /// password would look like a correct one and every 401 path would look
  /// dead. Demo logins: `cashier` / `cashier123`, `admin` / `admin123`,
  /// `manager` / `manager123`.
  static const _users = <String, String>{
    'cashier': 'cashier123',
    'admin': 'admin123',
    'manager': 'manager123',
  };

  Map<String, dynamic>? _matchUser(String login, String password) {
    // The real `/auth/login` rejects an empty password before it hashes
    // anything, so an empty one never matches even for a known login.
    if (password.isEmpty) return null;
    final expected = _users[login];
    if (expected == null || expected != password) return null;
    return _profileOf(login);
  }

  static Map<String, dynamic> _profileOf(String login) => switch (login) {
    'admin' => const {
      'first_name': 'Іван',
      'id': 2,
      'last_name': 'Адмін',
      'login': 'admin',
      'outlet_id': 1,
      'role': 'admin',
    },
    'manager' => const {
      'first_name': 'Марія',
      'id': 3,
      'last_name': 'Менеджер',
      'login': 'manager',
      'outlet_id': 1,
      'role': 'manager',
    },
    _ => const {
      'first_name': 'Олена',
      'id': 1,
      'last_name': 'Касір',
      'login': 'cashier',
      'outlet_id': 1,
      'role': 'cashier',
    },
  };

  @override
  Stream<String?> get onUnauthorized => _unauthorized.stream;

  DioException _wrapped(Object error, String path) {
    log('[MOCK API] Error on $path: $error');
    return DioException(
      requestOptions: RequestOptions(path: path),
      message: error.toString(),
    );
  }

  /// Answers a path this mock has no route for.
  ///
  /// A silent `200 {}` made a typo'd or unimplemented endpoint look like a
  /// working one that simply returned nothing, which is how a client could
  /// drift from the backend without anyone noticing. Gin answers an
  /// unregistered route with a bare 404 and no error envelope, so the mock does
  /// the same and throws: the repositories already branch on a 404 for exactly
  /// their absent routes, and the response body keeps the path diagnosable.
  Never _unhandled(String verb, String path) {
    log('[MOCK API] No route for $verb $path');
    throw DioException(
      requestOptions: RequestOptions(path: path),
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        data: {
          'code': 'NOT_FOUND',
          'message': 'Мок не реалізує цей маршрут: $verb $path',
        },
        statusCode: 404,
      ),
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) async {
    try {
      if (path.contains('/auth/me')) {
        if (_lastUser != null) {
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': _lastUser},
            statusCode: 200,
          );
        }
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {
            'code': 'UNAUTHORIZED',
            'message': 'Немає або недійсний токен',
          },
          statusCode: 401,
        );
      }

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
        final categoryId = _extractCategoryId(path);
        if (categoryId != null) {
          final products = await mockBackend.getProducts(categoryId);
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': products},
            statusCode: 200,
          );
        } else {
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
        final variantId = _extractVariantId(path);
        if (variantId != null) {
          final options = await mockBackend.getVariantOptions(variantId);
          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: {'data': options},
            statusCode: 200,
          );
        }
      } else if (path.contains('/ingredients')) {
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': const <List<dynamic>>[]},
          statusCode: 200,
        );
      }

      _unhandled('GET', path);
    } on DioException {
      rethrow;
    } catch (e) {
      throw _wrapped(e, path);
    }
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) async {
    try {
      // `POST /orders/{id}/confirm` — flips a pending (terminal) order to
      // `completed`. Must be matched before the generic `/orders` branch.
      if (RegExp(r'/orders/\d+/confirm').hasMatch(path)) {
        final orderId = _extractIdAfter(path, 'orders');
        final receipt = await mockBackend.confirmOrder(orderId!);
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': _receiptToJson(receipt)},
          statusCode: 200,
        );
      }

      // Terminal payment stand-ins, demoable until the real backend
      // implements `payments/create` / `payments/check`.
      if (path.contains('/payments/create')) {
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {
            'data': {
              'token':
                  'mock_terminal_token_'
                  '${DateTime.now().millisecondsSinceEpoch}',
              'expires': DateTime.now()
                  .add(const Duration(minutes: 10))
                  .toIso8601String(),
            },
          },
          statusCode: 200,
        );
      }
      if (path.contains('/payments/check')) {
        final transactionId =
            (data as Map<String, dynamic>?)?['transaction_id']?.toString() ??
            '';
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {
            'data': {
              'success': true,
              'status': 'SUCCESS',
              'rrn': '123456789012',
              'transaction_id': transactionId,
              'card_mask': '5168 **** **** 1234',
              'auth_code': '123456',
            },
          },
          statusCode: 200,
        );
      }

      if (path.contains('/orders')) {
        final orderData = data as Map<String, dynamic>?;
        if (orderData != null) {
          // `products[]`, the shape `OrdersRepositoryImpl` actually sends:
          // `{id, quantity (decimal string), options[]}` with
          // `payment.amount` as a UAH decimal string. Reading `items[]` instead
          // left the real payload unexercised in mock mode — every line came
          // through empty, and the only sales that ever worked were the ones a
          // test built by hand.
          final items =
              ((orderData['products'] as List<dynamic>?) ??
                      const <dynamic>[])
                  .map((item) {
                    final itemMap = item as Map<String, dynamic>;
                    return OrderLineDto(
                      productId: itemMap['id'].toString(),
                      quantity: parseDecimal(itemMap['quantity']),
                      options:
                          ((itemMap['options'] as List<dynamic>?) ??
                                  const <dynamic>[])
                              .map((opt) {
                                final optMap = opt as Map<String, dynamic>;
                                return SelectedOptionDto(
                                  optionId: parseInt(optMap['option_id']),
                                  quantity: parseInt(
                                    optMap['quantity'],
                                    fallback: 1,
                                  ),
                                );
                              })
                              .toList(),
                    );
                  })
                  .toList();

          final paymentData = orderData['payment'] as Map<String, dynamic>?;
          final paymentMethod = paymentData?['method'] as String? ?? 'cash';
          final tenderedKopecks = kopecksFromString(
            stringOr(paymentData?['amount'], '0'),
          );

          final receipt = await mockBackend.placeOrder(
            items: items,
            payment: PaymentDto(
              // `card` and `nfc` both map to the unified `terminal` method.
              method: PaymentMethod.fromWire(paymentMethod),
              tenderedKopecks: tenderedKopecks,
            ),
            idempotencyKey: idempotencyKey ?? '',
          );

          return Response<dynamic>(
            requestOptions: RequestOptions(path: path),
            data: _receiptToJson(receipt),
            statusCode: 201,
          );
        }
      } else if (path.contains('/auth/login')) {
        final loginData = data as Map<String, dynamic>?;
        final login = loginData?['login'] as String? ?? '';
        final password = loginData?['password'] as String? ?? '';
        log('[MOCK API] Login attempt for user: $login');

        if (login.isEmpty || password.isEmpty) {
          return Response(
            requestOptions: RequestOptions(path: path),
            data: {
              'code': 'INVALID_REQUEST',
              'message': "Логін і пароль обов'язкові",
            },
            statusCode: 400,
          );
        }

        final user = _matchUser(login, password);
        if (user == null) {
          return Response(
            requestOptions: RequestOptions(path: path),
            data: {
              'code': 'UNAUTHORIZED',
              'message': 'Невірний логін або пароль',
            },
            statusCode: 401,
          );
        }

        final accessToken =
            'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        const refreshToken = 'mock_refresh_token';
        _lastUser = user;

        return Response(
          requestOptions: RequestOptions(path: path),
          headers: Headers.fromMap({
            'authorization': ['Bearer $accessToken'],
          }),
          data: {
            'data': {
              'first_name': user['first_name'],
              'id': user['id'],
              'last_name': user['last_name'],
              'login': user['login'],
              'outlet_id': user['outlet_id'],
              'refresh_token': refreshToken,
              'role': user['role'],
            },
          },
          statusCode: 200,
        );
      } else if (path.contains('/auth/logout')) {
        log('[MOCK API] Logout');
        _lastUser = null;
        return Response(
          requestOptions: RequestOptions(path: path),
          statusCode: 204,
        );
      } else if (path.contains('/auth/refresh')) {
        log('[MOCK API] Token refresh');

        if (MockBackend.forceRefreshFailure) {
          return Response(
            requestOptions: RequestOptions(path: path),
            statusCode: 401,
          );
        }

        final newToken =
            'mock_token_refreshed_${DateTime.now().millisecondsSinceEpoch}';

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

      _unhandled('POST', path);
    } on DioException {
      rethrow;
    } catch (e) {
      throw _wrapped(e, path);
    }
  }

  @override
  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
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
      _unhandled('PATCH', path);
    } on DioException {
      rethrow;
    } catch (e) {
      throw _wrapped(e, path);
    }
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
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
      _unhandled('PUT', path);
    } on DioException {
      rethrow;
    } catch (e) {
      throw _wrapped(e, path);
    }
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    String? idempotencyKey,
    Map<String, dynamic>? headers,
    Duration? timeout,
  }) async {
    try {
      if (path.contains('/categories/')) {
        final id = _extractIdAfter(path, 'categories');
        await mockBackend.deleteAdminCategory(id: id!);
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 204,
        );
      } else if (path.contains('/products/')) {
        final id = _extractIdAfter(path, 'products');
        await mockBackend.deleteAdminProduct(id: id!);
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 204,
        );
      } else if (path.contains('/variants/')) {
        final id = _extractIdAfter(path, 'variants');
        await mockBackend.deleteAdminVariant(id: id!);
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 204,
        );
      }
      _unhandled('DELETE', path);
    } on DioException {
      rethrow;
    } catch (e) {
      throw _wrapped(e, path);
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

  int? _extractVariantId(String path) {
    final match = RegExp(r'/variants/(\d+)/options').firstMatch(path);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return null;
  }

  /// Serializes a [OrderReceipt] into the order-response shape used by
  /// `POST /orders` and `POST /orders/{id}/confirm` (decimal-string money).
  Map<String, dynamic> _receiptToJson(OrderReceipt receipt) =>
      <String, dynamic>{
        'order_id': receipt.orderId,
        'items': receipt.lines
            .map(
              (line) => <String, dynamic>{
                'variant_id': line.productId,
                'name': line.name,
                'quantity': line.quantity,
                'unit_price': formatAmount(line.unitPriceKopecks),
                'line_total': formatAmount(line.subtotalKopecks),
              },
            )
            .toList(),
        'total_price': formatAmount(receipt.totalKopecks),
        'payment': <String, String>{
          'method': receipt.method.wire,
          'tendered': formatAmount(receipt.tenderedKopecks),
          'change': formatAmount(receipt.changeKopecks),
        },
        'status': receipt.status,
        'created_at': receipt.issuedAt.toIso8601String(),
      };
}
