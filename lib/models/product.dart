class Product {
  final int id;
  final String name;
  final String slug;
  final double price;
  final String? image;
  final String? description;
  final String? category;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    this.image,
    this.description,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['image'];

    // Step 2: Robust image URL resolver
    if (imageUrl == null || imageUrl.isEmpty) {
      imageUrl = null;
    } else if (!imageUrl.startsWith('http')) {
      // Build the full image URL by prefixing only the backend domain
      final String baseUrl = "https://whisker-cart.onrender.com";
      // Ensure there is a slash between domain and path
      if (imageUrl.startsWith('/')) {
        imageUrl = "$baseUrl$imageUrl";
      } else {
        imageUrl = "$baseUrl/$imageUrl";
      }
    }

    // Try to get category name from nested object or string
    String? categoryName;
    if (json['category'] != null) {
      if (json['category'] is String) {
        categoryName = json['category'];
      } else if (json['category'] is Map) {
        categoryName = json['category']['name'];
      }
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      price: _parsePrice(json['price']),
      image: imageUrl,
      description: json['description'],
      category: categoryName,
    );
  }

  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      // Handle cases like "2500.00" or "Rs. 2500.00"
      final match = RegExp(r'([0-9]+(?:\.[0-9]+)?)').firstMatch(price);
      if (match != null) {
        return double.tryParse(match.group(1)!) ?? 0.0;
      }
    }
    return 0.0;
  }
}
