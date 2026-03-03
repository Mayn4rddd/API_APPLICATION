import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';

/// A simple API service for accessing FakeStore products.
///
/// Uses a custom [IOClient] that installs an [HttpClient] with
/// `badCertificateCallback` set to `true` so SSL certificate
/// errors are ignored during development (matching the global
/// override installed in `main.dart`).
///
/// **Warning**: This bypass is strictly for testing and should be
/// removed or guarded in production builds.
class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // cached products for favorites screen
  static List<Product> cachedProducts = [];

  static Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse('$_baseUrl/products');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final products = jsonList
          .map((e) => Product.fromApi(e as Map<String, dynamic>))
          .toList();
      cachedProducts = products;
      return products;
    } else {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }
  }

  /// Fetches product categories from the FakeStore API.
  static Future<List<String>> fetchCategories() async {
    final uri = Uri.parse('$_baseUrl/products/categories');
    final response = await http.get(uri);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to fetch categories: ${response.statusCode}');
    }
  }

  /// Sends credentials to FakeStore API and returns the auth token.
  ///
  /// Throws an [Exception] if login fails for any reason.
  static Future<String> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    // FakeStore sometimes returns 201 for this endpoint (indicating created
    // or successful response). Accept any 2xx status code as success so long as
    // a token is present.
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('token')) {
        return data['token'] as String;
      } else {
        throw Exception(
          'Login succeeded (${response.statusCode}) but token missing',
        );
      }
    } else {
      // include body so we can debug unexpected responses
      throw Exception(
        'Login failed: status=${response.statusCode}, body=${response.body}',
      );
    }
  }
}
