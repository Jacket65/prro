import 'dart:async';

import 'package:dio/dio.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/core/mock/order_request_dto.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/utils/json.dart';
import 'package:prro/core/utils/money.dart';
import 'package:talker/talker.dart';

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
///
/// Which routes this transport answers is decided per path, not per feature:
/// a branch survives only when the client can actually reach it through this
/// transport or when it deliberately mirrors the backend's current answer for
/// a route it owns. In the mock environment every repository except
/// `AuthRepositoryI` (its implementation is registered for all environments)
/// is backed by a repository-level `*Mock` that talks to `MockBackend`
/// directly, so the admin/items branches below were unreachable dead weight
/// that also answered undecodably (Dart model objects where the clients call
/// `unwrapList`/`unwrapObject` + `fromJson`). They now 404 through
/// [_unhandled] like any other unrouted path, and the branches that remain
/// serve the auth transport and the order/payment client paths.
class MockApiClient implements ApiClientI {
  MockApiClient({required this.mockBackend, required this._talker});

  final MockBackend mockBackend;
  final Talker _talker;
  final StreamController<String?> _unauthorized =
      StreamController<String?>.broadcast();

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
    _talker.error('[MOCK API] Error on $path: $error');
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
    _talker.warning('[MOCK API] No route for $verb $path');
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
      // Bare `/retail-outlets/` — the one admin-shaped read the auth transport
      // still needs: `AuthRepositoryImpl._firstOutletId` reads it when a login
      // payload carries no `outlet_id`. JSON maps on the wire, exactly like the
      // server's `HandleOutletList`, because the consumer decodes with
      // `unwrapList` and reads `m['id']`.
      if (RegExp(r'/retail-outlets/?$').hasMatch(path)) {
        final outlets = await mockBackend.getAdminOutlets();
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {
            'data': [
              for (final o in outlets)
                {
                  'id': o.id,
                  'name': o.name,
                  'address': o.address,
                  'city': o.city,
                  'is_active': o.isActive,
                },
            ],
          },
          statusCode: 200,
        );
      }

      // Every other read was unreachable in the mock environment — the
      // repository-level mocks (`ItemsRepositoryMock`,
      // `AdminCatalogRepositoryMock`, `AdminUserRepositoryMock`) intercept
      // before the transport — and answered undecodably, so it is gone:
      // `GET /auth/me` (no client interface calls it),
      // `GET /retail-outlets/{id}/users`, `/categories`, `/ingredients`,
      // `GET /measure-units`, `GET /categories`, `GET /products`,
      // `GET /variants/{id}/options`, and the bare `GET /ingredients` (the
      // client's ingredient route is always outlet-scoped).

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
              ((orderData['products'] as List<dynamic>?) ?? const <dynamic>[])
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
        _talker.info('[MOCK API] Login attempt for user: $login');

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
        _talker.info('[MOCK API] Logout');
        return Response(
          requestOptions: RequestOptions(path: path),
          statusCode: 204,
        );
      } else if (path.contains('/auth/refresh')) {
        _talker.info('[MOCK API] Token refresh');

        if (mockBackend.forceRefreshFailure) {
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
      }
      // The admin create branches (`POST /retail-outlets/{id}/categories`,
      // `POST /categories/{id}/products`, `POST /products/{id}/variants`) were
      // unreachable in the mock environment and answered undecodably; they now
      // fall through to the 404 below.

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
        // Kept on purpose: `PATCH /categories/{id}` is registered and working
        // on the server (routes.go:75). The payload is the wire shape
        // (`AdminCategory.toJson`), so `AdminCategory.fromJson` can decode it.
        final id = _extractIdAfter(path, 'categories');
        final category = await mockBackend.updateAdminCategory(
          id: id!,
          name: _nameOf(data),
        );
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          data: {'data': category.toJson()},
          statusCode: 200,
        );
      } else if (path.contains('/products/')) {
        // `PATCH /products/{id}` is routed (routes.go:86 → HandleProductUpdate)
        // but always fails there: the handler saves a partial `Product`
        // (id + name), GORM zeroes `category_id`, and the insert violates the
        // FK (23503) → 500. The mock mirrors that failure — same envelope, same
        // untouched store — instead of succeeding where its server cannot.
        throw _registeredButBroken(path);
      }
      // `PATCH /variants/{id}` is commented out of the router (routes.go:106),
      // so it falls through to the 404 below, exactly like DELETE below.

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
      // `PUT /variants/{id}/recipe` was unreachable in the mock environment
      // (AdminCatalogRepositoryMock → MockBackend.replaceAdminRecipe) and its
      // payload was undecodable; the route now falls through to the 404 below.
      // The MockBackend no-op it used to reach is still pinned by the
      // repository-level tests, and the client path itself is unchanged.
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
      // Kept: both routes are registered and working on the server
      // (routes.go:76, :87) and both answer 204 with an empty body, so there is
      // no payload to decode.
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
      }
      // `DELETE /variants/{id}` is commented out of the router (routes.go:107),
      // so it falls through to the 404 below.

      _unhandled('DELETE', path);
    } on DioException {
      rethrow;
    } catch (e) {
      throw _wrapped(e, path);
    }
  }

  /// Answers a route the backend registers but cannot complete (`PATCH
  /// /products/{id}`, `handle_product.go:38-51`): GORM saves a partial
  /// `Product`, zeroes `category_id`, the insert violates the FK (23503) and
  /// the server answers 500 with its standard envelope. The client maps
  /// `internal_error` to 'Помилка сервера.' — the same sentence a production
  /// user sees today.
  DioException _registeredButBroken(String path) {
    _talker.error('[MOCK API] $path is routed but broken on the server');
    return DioException(
      requestOptions: RequestOptions(path: path),
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: path),
        data: {
          'error': {
            'code': 'internal_error',
            'message': 'internal server error',
          },
        },
        statusCode: 500,
      ),
      type: DioExceptionType.badResponse,
    );
  }

  int? _extractIdAfter(String path, String segment) {
    final match = RegExp('/$segment/(\\d+)').firstMatch(path);
    return match == null ? null : int.parse(match.group(1)!);
  }

  String _nameOf(dynamic data) =>
      (data as Map<String, dynamic>?)?['name']?.toString().trim() ?? '';

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
