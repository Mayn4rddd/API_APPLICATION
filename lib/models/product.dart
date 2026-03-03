// Unified product model for both sample data and API
class Product {
  final int id;
  final String name; // mapped from API "title"
  final String category;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final int reviews;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviews,
    this.isFavorite = false,
  });

  factory Product.fromApi(Map<String, dynamic> json) {
    final ratingObj = json['rating'] ?? {};
    return Product(
      id: json['id'] as int,
      name: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (ratingObj['rate'] as num?)?.toDouble() ?? 0.0,
      reviews: (ratingObj['count'] as num?)?.toInt() ?? 0,
    );
  }
}

// note: sampleProducts removed; use API fetch for dynamic content
