import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productService.fetchProducts();
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> fetchProductDetail(String slug) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedProduct = null;
    notifyListeners();

    try {
      // Try fetching from API
      _selectedProduct = await _productService.fetchProductDetail(slug);
    } catch (e) {
      // If API fails, check if it's one of the featured/offline items
      try {
        final String jsonString = await _productService.loadOfflineJson();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        final featuredData = jsonList.firstWhere(
          (item) =>
              item['slug'] == slug ||
              item['name'].toString().toLowerCase().replaceAll(' ', '-') ==
                  slug,
          orElse: () => null,
        );

        if (featuredData != null) {
          _selectedProduct = Product(
            id: -1,
            name: featuredData['name'],
            slug: slug,
            price: (featuredData['price'] as num).toDouble(),
            description: featuredData['description'],
            image: featuredData['image'],
          );
        } else {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
      } catch (innerError) {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      }
    }
    _isLoading = false;
    notifyListeners();
  }
}
