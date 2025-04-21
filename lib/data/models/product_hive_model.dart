import 'package:hive/hive.dart';

part 'product_hive_model.g.dart'; // VERY IMPORTANT

@HiveType(typeId: 0)
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String image;
  @HiveField(4)
  double price;
  @HiveField(5)
  double rating;
  @HiveField(6)
  int ratingCount;
  @HiveField(7)
  bool isFavorite;

  ProductHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.ratingCount,
    this.isFavorite = false,
  });

  factory ProductHiveModel.fromJson(Map<String, dynamic> json) {
    return ProductHiveModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating']['rate'] as num).toDouble(),
      ratingCount: json['rating']['count'],
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
