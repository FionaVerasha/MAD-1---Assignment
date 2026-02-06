class FeaturedItem {
  final String name;
  final double price;
  final String image;
  final String description;
  final String slug;

  FeaturedItem({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.slug,
  });

  factory FeaturedItem.fromJson(Map<String, dynamic> json) {
    return FeaturedItem(
      name: json['name'] ?? 'Pet Product',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      slug:
          json['slug'] ??
          (json['name'] ?? '').toString().toLowerCase().replaceAll(' ', '-'),
    );
  }
}
