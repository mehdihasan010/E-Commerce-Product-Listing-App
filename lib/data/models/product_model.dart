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
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating']['rate'] as num).toDouble(),
      ratingCount: json['rating']['count'],
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
