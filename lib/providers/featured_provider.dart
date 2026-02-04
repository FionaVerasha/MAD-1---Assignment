import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/featured_item.dart';

class FeaturedProvider extends ChangeNotifier {
  List<FeaturedItem> _featuredItems = [];
  bool _isLoading = false;
  String? _error;

  List<FeaturedItem> get featuredItems => _featuredItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Placeholder URL for external JSON
  final String _externalJsonUrl =
      "https://raw.githubusercontent.com/FionaVerasha/MAD-1---Assignment/main/assets/json/featured_offline.json";

  Future<void> fetchFeaturedItems(bool isOnline) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (isOnline) {
      try {
        final response = await http
            .get(Uri.parse(_externalJsonUrl))
            .timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          _featuredItems = data
              .map((item) => FeaturedItem.fromJson(item))
              .toList();
          _isLoading = false;
          notifyListeners();
          return;
        }
      } catch (e) {
        debugPrint("External fetch failed, falling back to local: $e");
      }
    }

    // Fallback to local JSON
    try {
      final String localData = await rootBundle.loadString(
        'assets/json/featured_offline.json',
      );
      final List<dynamic> data = json.decode(localData);
      _featuredItems = data.map((item) => FeaturedItem.fromJson(item)).toList();
    } catch (e) {
      _error = "Failed to load featured items";
      debugPrint("Local fetch failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
