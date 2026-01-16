import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:prro/items_screen/models/measure.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8080';
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<String> loginAdmin({
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/admin');
    final body = jsonEncode({
      'password': password,
      'phone_number': phoneNumber,
    });

    final response = await http.post(url, headers: _defaultHeaders, body: body);

    if (response.statusCode == 200) {
      // Припустимо, токен повертається у заголовку “Authorization”
      final authHeader = response.headers['authorization'];
      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        final token = authHeader.substring(7); // видаляємо "Bearer "
        // Зберігаємо токен
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return token;
      } else {
        // Якщо токен у тілі:
        final Map<String, dynamic> data = jsonDecode(response.body);
        final token = data['token'] as String?;
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          return token;
        }
      }
      throw Exception('Token not found in response');
    } else {
      throw Exception('Failed login: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<dynamic>> fetchRetailOutlets() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse('$_baseUrl/admin/retail_outlets');
    final response = await http.get(
      url,
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final outlets = data['data'] as List<dynamic>;
      return outlets;
    } else if (response.statusCode == 401) {
      // токен не валідний або прострочений
      throw Exception('Unauthorized – invalid token');
    } else {
      throw Exception(
        'Failed to load outlets: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<dynamic>> fetchRetailSeller({required int retailOutlet}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse(
      '$_baseUrl/admin/retail_outlet/$retailOutlet/sellers',
    );
    final response = await http.get(
      url,
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final outlets = data['data'] as List<dynamic>;
      log("Outlets $outlets");
      return outlets;
    } else if (response.statusCode == 401) {
      // токен не валідний або прострочений
      throw Exception('Unauthorized – invalid token');
    } else {
      throw Exception(
        'Failed to load outlets: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<dynamic>> fetchCategories({required int retailOutlet}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse(
      '$_baseUrl/admin/retail_outlet/$retailOutlet/categories',
    );

    final response = await http.get(
      url,
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final categories = data['data'] as List<dynamic>;
      log("Categories $categories");
      return categories;
    } else if (response.statusCode == 401) {
      // токен не валідний або прострочений
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse('$_baseUrl/admin/category');

    final response = await http.post(
      body: jsonEncode({"name": name, "retail_outlet_id": outletId}),
      url,
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      log("Category created: $data");
      return [data];
    } else if (response.statusCode == 401) {
      // токен не валідний або прострочений
      throw Exception('Unauthorized – invalid token');
    } else {
      throw Exception(
        'Failed to load categories: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<dynamic>> fetchProducts({
    required int retailOutlet,
    required int categoryId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse(
      '$_baseUrl/admin/retail_outlet/$retailOutlet/category/$categoryId',
    );
    final response = await http.get(
      url,
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final items = data['data'] as List<dynamic>;
      // Витягуємо тільки "products"
      final products = items.map((entry) => entry['products']).toList();
      log("Products only: $products");
      return products
          .map(
            (p) => [
              p['name'].toString(),
              p['measure_units_id'].toString(),
              '-',
              '-',
              '-',
              '-',
            ],
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load products: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<Measure>> fetchMeasures() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse('$_baseUrl/admin/measureunits');
    final response = await http.get(
      url,
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final items = data['data'] as List<dynamic>;

      final measure = items
          .map((entry) => Measure(id: entry['id'], name: entry['name']))
          .toList();
      log("Measures only: ${measure.map((e) => e.name).toList()}");
      return measure;
    } else {
      throw Exception(
        'Failed to load measures: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> createProduct({
    required int measureId,
    required String name,
    required int categoryId,
    required int outletId,
    required int price,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }

    final url = Uri.parse('$_baseUrl/admin/product');
    final response = await http.post(
      body: jsonEncode({
        "category_id": categoryId,
        "measure_units_id": measureId,
        "name": name,
        "price": price,
        "retail_outlet_id": outletId,
      }),

      url,
      headers: {..._defaultHeaders, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      log("Product created: $data");

      return data;
    } else {
      throw Exception(
        'Failed to load products: ${response.statusCode} ${response.body}',
      );
    }
  }
}
