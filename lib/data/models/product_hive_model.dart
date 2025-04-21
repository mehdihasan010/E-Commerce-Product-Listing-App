import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ProductHiveModel extends HiveObject {
  @HiveField(0) int id;
  @HiveField(1) String title;
  @HiveField(2) String description;
  @HiveField(3) String image;
  @HiveField(4) double price;
  @HiveField(5) double rating;
  @HiveField(6) int ratingCount;

  ProductHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.ratingCount,
  });

  factory ProductHiveModel.fromJson(Map<String, dynamic> json) => ProductHiveModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    image: json['image'],
    price: (json['price'] as num).toDouble(),
    rating: (json['rating']['rate'] as num).toDouble(),
    ratingCount: json['rating']['count'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'image': image,
    'price': price,
    'rating': rating,
    'ratingCount': ratingCount,
  };
}
