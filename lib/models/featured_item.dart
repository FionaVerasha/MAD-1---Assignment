class FeaturedItem {
  final String name;
  final double price;
  final String image;
  final String description;

  FeaturedItem({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  factory FeaturedItem.fromJson(Map<String, dynamic> json) {
    return FeaturedItem(
      name: json['name'] ?? 'Pet Product',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
