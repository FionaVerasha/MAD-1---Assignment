import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ProductService {
  final String _baseUrl = "https://whisker-cart.onrender.com/api";

  Future<String> loadOfflineJson() async {
    return await rootBundle.loadString('assets/json/featured_offline.json');
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<Product>> fetchProducts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/products'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> data;
      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map && decoded.containsKey('data')) {
        data = decoded['data'];
      } else {
        data = [];
      }

      return data.map((json) => Product.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<Product> fetchProductDetail(String slug) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/products/$slug'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final Map<String, dynamic> data =
          (decoded is Map && decoded.containsKey('data'))
          ? decoded['data']
          : decoded;
      return Product.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Product not found.');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else {
      throw Exception('Failed to load product details: ${response.statusCode}');
    }
  }
}
