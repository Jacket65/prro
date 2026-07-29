import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:prro/features/admin/screens/items_screen/models/measure.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class ApiService {
  static const String _baseUrl = 'http://pos.coffeebeans.space.test/api/v1';
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Fallback list matching the seeded units in `cmd/seeder/main.go`, used only
  // if `GET /measure-units` is unreachable.
  static const List<Measure> _stubMeasures = [
    Measure(id: 1, name: 'г'),
    Measure(id: 2, name: 'мл'),
    Measure(id: 3, name: 'шт'),
  ];

  final Random _rng = Random.secure();

  String _idempotencyKey() {
    final ts = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    final rand = _rng.nextInt(0xFFFFFFFF).toRadixString(16).padLeft(8, '0');
    return '$ts-$rand';
  }

  Future<String> _authToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('No auth token found');
    }
    return token;
  }

  Future<Map<String, String>> _authHeaders({bool idempotent = false}) async {
    final token = await _authToken();
    final headers = {..._defaultHeaders, 'Authorization': 'Bearer $token'};
    if (idempotent) {
      headers['Idempotency-Key'] = _idempotencyKey();
    }
    return headers;
  }

  Future<String> loginAdmin({
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    final body = jsonEncode({'login': phoneNumber, 'password': password});

    final response = await http.post(url, headers: _defaultHeaders, body: body);

    if (response.statusCode == 200) {
      final authHeader = response.headers['authorization'];
      if (authHeader != null &&
          authHeader.toLowerCase().startsWith('bearer ')) {
        final token = authHeader.substring(7).trim();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return token;
      }
      throw Exception('Token not found in response headers');
    } else {
      throw Exception('Failed login: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRetailOutlets() async {
    final url = Uri.parse('$_baseUrl/retail-outlets/');
    final response = await http.get(url, headers: await _authHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final outlets = data['data'] as List<dynamic>? ?? [];
      return outlets.map((e) => e as Map<String, dynamic>).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized – invalid token');
    } else {
      throw Exception(
        'Failed to load outlets: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<dynamic>> fetchRetailSeller({required int retailOutlet}) async {
    final url = Uri.parse('$_baseUrl/retail-outlets/$retailOutlet/users');
    final response = await http.get(url, headers: await _authHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final users = data['data'] as List<dynamic>? ?? <dynamic>[];
      log('Users in outlet $retailOutlet: $users');
      return users;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized – invalid token');
    } else {
      throw Exception(
        'Failed to load users: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<dynamic>> fetchCategories({required int retailOutlet}) async {
    final url = Uri.parse('$_baseUrl/retail-outlets/$retailOutlet/categories');
    final response = await http.get(url, headers: await _authHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final categories = data['data'] as List<dynamic>? ?? <dynamic>[];
      log('Categories: $categories');
      return categories;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized – invalid token');
    } else {
      throw Exception(
        'Failed to load categories: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<dynamic>> createCategories({
    required String name,
    required int outletId,
  }) async {
    final url = Uri.parse('$_baseUrl/retail-outlets/$outletId/categories');
    final response = await http.post(
      url,
      headers: await _authHeaders(idempotent: true),
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      log('Category created: $data');
      return [data['data']];
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized – invalid token');
    } else {
      throw Exception(
        'Failed to create category: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> updateCategory({
    required int id,
    required String name,
  }) async {
    final url = Uri.parse('$_baseUrl/categories/$id');
    final response = await http.patch(
      url,
      headers: await _authHeaders(),
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['data'] as Map).cast<String, dynamic>();
    }
    throw Exception(
      'Failed to update category: ${response.statusCode} ${response.body}',
    );
  }

  Future<void> deleteCategory({required int id}) async {
    final url = Uri.parse('$_baseUrl/categories/$id');
    final response = await http.delete(url, headers: await _authHeaders());
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(
        'Failed to delete category: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Returns raw product objects: `[{ id, name }, ...]`.
  Future<List<Map<String, dynamic>>> fetchProducts({
    required int categoryId,
  }) async {
    final url = Uri.parse('$_baseUrl/categories/$categoryId/products');
    final response = await http.get(url, headers: await _authHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['data'] as List<dynamic>? ?? <dynamic>[];
      return items
          .whereType<Map<String, dynamic>>()
          .map((m) => m.cast<String, dynamic>())
          .toList();
    }
    throw Exception(
      'Failed to load products: ${response.statusCode} ${response.body}',
    );
  }

  Future<List<Measure>> fetchMeasures() async {
    try {
      final url = Uri.parse('$_baseUrl/measure-units');
      final response = await http.get(url, headers: await _authHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final items = data['data'] as List<dynamic>? ?? <dynamic>[];
        final measures = items
            .whereType<Map<String, dynamic>>()
            .map(
              (m) => Measure(
                id: (m['id'] as num?)?.toInt() ?? 0,
                name: (m['name'] ?? '').toString(),
              ),
            )
            .toList();
        if (measures.isNotEmpty) return measures;
      }
    } on Object catch (e) {
      log('fetchMeasures failed, using stub: $e');
    }
    return _stubMeasures;
  }

  Future<Map<String, dynamic>> createProduct({
    required int measureId,
    required String name,
    required int categoryId,
    required int outletId,
    required int price,
  }) async {
    // Current product create accepts only { name };
    // category id lives in the URL
    // measureId / price / outletId are unused server-side until the schema catches up.
    final url = Uri.parse('$_baseUrl/categories/$categoryId/products');
    final response = await http.post(
      url,
      headers: await _authHeaders(idempotent: true),
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      log('Product created: $data');
      return data;
    } else {
      throw Exception(
        'Failed to create product: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> updateProduct({
    required int id,
    required String name,
  }) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    final response = await http.patch(
      url,
      headers: await _authHeaders(),
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['data'] as Map).cast<String, dynamic>();
    }
    throw Exception(
      'Failed to update product: ${response.statusCode} ${response.body}',
    );
  }

  Future<void> deleteProduct({required int id}) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    final response = await http.delete(url, headers: await _authHeaders());
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(
        'Failed to delete product: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchVariants({
    required int productId,
  }) async {
    final url = Uri.parse('$_baseUrl/products/$productId/variants');
    final response = await http.get(url, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['data'] as List<dynamic>? ?? <dynamic>[];
      return items
          .whereType<Map<String, dynamic>>()
          .map((m) => m.cast<String, dynamic>())
          .toList();
    }
    throw Exception(
      'Failed to load variants: ${response.statusCode} ${response.body}',
    );
  }

  Future<Map<String, dynamic>> createVariant({
    required int productId,
    required String name,
    required double price,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    final url = Uri.parse('$_baseUrl/products/$productId/variants');
    final response = await http.post(
      url,
      headers: await _authHeaders(idempotent: true),
      body: jsonEncode({
        'name': name,
        'price': price,
        'ingredients': ingredients,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['data'] as Map).cast<String, dynamic>();
    }
    throw Exception(
      'Failed to create variant: ${response.statusCode} ${response.body}',
    );
  }

  Future<Map<String, dynamic>> updateVariant({
    required int id,
    required String name,
    required double price,
  }) async {
    final url = Uri.parse('$_baseUrl/variants/$id');
    final response = await http.patch(
      url,
      headers: await _authHeaders(),
      body: jsonEncode({'name': name, 'price': price}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['data'] as Map).cast<String, dynamic>();
    }
    throw Exception(
      'Failed to update variant: ${response.statusCode} ${response.body}',
    );
  }

  Future<void> deleteVariant({required int id}) async {
    final url = Uri.parse('$_baseUrl/variants/$id');
    final response = await http.delete(url, headers: await _authHeaders());
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(
        'Failed to delete variant: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecipe({
    required int variantId,
  }) async {
    final url = Uri.parse('$_baseUrl/variants/$variantId/recipe');
    final response = await http.get(url, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['data'] as List<dynamic>? ?? <dynamic>[];
      return items
          .whereType<Map<String, dynamic>>()
          .map((m) => m.cast<String, dynamic>())
          .toList();
    }
    throw Exception(
      'Failed to load recipe: ${response.statusCode} ${response.body}',
    );
  }

  Future<void> replaceRecipe({
    required int variantId,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    final url = Uri.parse('$_baseUrl/variants/$variantId/recipe');
    final response = await http.put(
      url,
      headers: await _authHeaders(),
      body: jsonEncode({'ingredients': ingredients}),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to replace recipe: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchIngredients({
    required int outletId,
  }) async {
    final url = Uri.parse('$_baseUrl/retail-outlets/$outletId/ingredients');
    final response = await http.get(url, headers: await _authHeaders());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['data'] as List<dynamic>? ?? <dynamic>[];
      return items
          .whereType<Map<String, dynamic>>()
          .map((m) => m.cast<String, dynamic>())
          .toList();
    }
    throw Exception(
      'Failed to load ingredients: ${response.statusCode} ${response.body}',
    );
  }
}
