import 'package:hive/hive.dart';

part 'product_hive_model.g.dart';

@HiveType(typeId: 0)
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String category;
  @HiveField(4)
  double price;
  @HiveField(5)
  double discountPercentage;
  @HiveField(6)
  double? rating;
  @HiveField(7)
  int stock;
  @HiveField(8)
  List<String> tags;
  @HiveField(9)
  String brand;
  @HiveField(10)
  String sku;
  @HiveField(11)
  double weight;
  @HiveField(12)
  Map<String, double> dimensions;
  @HiveField(13)
  String warrantyInformation;
  @HiveField(14)
  String shippingInformation;
  @HiveField(15)
  String availabilityStatus;
  @HiveField(16)
  List<ProductReviewHive> reviews;
  @HiveField(17)
  String returnPolicy;
  @HiveField(18)
  int minimumOrderQuantity;
  @HiveField(19)
  ProductMetaHive meta;
  @HiveField(20)
  List<String> images;
  @HiveField(21)
  String thumbnail;
  @HiveField(22)
  bool isFavorite;

  ProductHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
    this.isFavorite = false,
  });

  factory ProductHiveModel.fromJson(Map<String, dynamic> json) {
    return ProductHiveModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      stock: json['stock'] as int,
      tags: List<String>.from(json['tags']),
      brand: json['brand'] as String,
      sku: json['sku'] as String,
      weight: (json['weight'] as num).toDouble(),
      dimensions: Map<String, double>.from(
        json['dimensions'].map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      warrantyInformation: json['warrantyInformation'] as String,
      shippingInformation: json['shippingInformation'] as String,
      availabilityStatus: json['availabilityStatus'] as String,
      reviews:
          (json['reviews'] as List)
              .map(
                (review) => ProductReviewHive(
                  rating: review['rating'] as int,
                  comment: review['comment'] as String,
                  date: DateTime.parse(review['date'] as String),
                  reviewerName: review['reviewerName'] as String,
                  reviewerEmail: review['reviewerEmail'] as String,
                ),
              )
              .toList(),
      returnPolicy: json['returnPolicy'] as String,
      minimumOrderQuantity: json['minimumOrderQuantity'] as int,
      meta: ProductMetaHive(
        createdAt: DateTime.parse(json['meta']['createdAt'] as String),
        updatedAt: DateTime.parse(json['meta']['updatedAt'] as String),
        barcode: json['meta']['barcode'] as String,
        qrCode: json['meta']['qrCode'] as String,
      ),
      images: List<String>.from(json['images']),
      thumbnail: json['thumbnail'] as String,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'discountPercentage': discountPercentage,
    'rating': rating,
    'stock': stock,
    'tags': tags,
    'brand': brand,
    'sku': sku,
    'weight': weight,
    'dimensions': dimensions,
    'warrantyInformation': warrantyInformation,
    'shippingInformation': shippingInformation,
    'availabilityStatus': availabilityStatus,
    'reviews':
        reviews
            .map(
              (review) => {
                'rating': review.rating,
                'comment': review.comment,
                'date': review.date.toIso8601String(),
                'reviewerName': review.reviewerName,
                'reviewerEmail': review.reviewerEmail,
              },
            )
            .toList(),
    'returnPolicy': returnPolicy,
    'minimumOrderQuantity': minimumOrderQuantity,
    'meta': {
      'createdAt': meta.createdAt.toIso8601String(),
      'updatedAt': meta.updatedAt.toIso8601String(),
      'barcode': meta.barcode,
      'qrCode': meta.qrCode,
    },
    'images': images,
    'thumbnail': thumbnail,
    'isFavorite': isFavorite,
  };
}

@HiveType(typeId: 1)
class ProductReviewHive {
  @HiveField(0)
  int rating;
  @HiveField(1)
  String comment;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  String reviewerName;
  @HiveField(4)
  String reviewerEmail;

  ProductReviewHive({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });
}

@HiveType(typeId: 2)
class ProductMetaHive {
  @HiveField(0)
  DateTime createdAt;
  @HiveField(1)
  DateTime updatedAt;
  @HiveField(2)
  String barcode;
  @HiveField(3)
  String qrCode;

  ProductMetaHive({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });
}
