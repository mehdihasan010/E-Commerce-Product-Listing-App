import 'package:ecommerce_product_listing_app/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.image,
    required super.price,
    required super.rating,
    required super.ratingCount,
    super.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle both nested and flat rating formats
    final rating =
        json['rating'] is Map
            ? (json['rating']['rate'] as num).toDouble()
            : (json['rating'] as num).toDouble();
    final ratingCount =
        json['rating'] is Map ? json['rating']['count'] : json['ratingCount'];

    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      rating: rating,
      ratingCount: ratingCount,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'image': image,
    'price': price,
    'rating': rating,
    'ratingCount': ratingCount,
    'isFavorite': isFavorite,
  };
}
