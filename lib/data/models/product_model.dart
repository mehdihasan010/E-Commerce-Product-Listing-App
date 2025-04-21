import 'dart:convert';
import 'package:ecommerce_product_listing_app/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.discountPercentage,
    super.rating,
    required super.stock,
    required super.tags,
    required super.brand,
    required super.sku,
    required super.weight,
    required super.dimensions,
    required super.warrantyInformation,
    required super.shippingInformation,
    required super.availabilityStatus,
    required super.reviews,
    required super.returnPolicy,
    required super.minimumOrderQuantity,
    required super.meta,
    required super.images,
    required super.thumbnail,
    super.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse numbers
    double safeDouble(dynamic value, [double defaultValue = 0.0]) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    int safeInt(dynamic value, [int defaultValue = 0]) {
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    // Safely parse dimensions map
    Map<String, double> parseDimensions(dynamic dimensionsJson) {
      if (dimensionsJson is Map) {
        return Map<String, double>.from(
          dimensionsJson.map(
            (key, value) => MapEntry(key.toString(), safeDouble(value)),
          ),
        );
      }
      return {}; // Default to empty map if not a map
    }

    // Safely parse reviews list
    List<ProductReview> parseReviews(dynamic reviewsJson) {
      if (reviewsJson is List) {
        return reviewsJson
            .map((review) {
              if (review is Map<String, dynamic>) {
                return ProductReview(
                  rating: safeInt(review['rating']), // Use safeInt
                  comment: review['comment'] as String? ?? '',
                  date:
                      DateTime.tryParse(review['date'] as String? ?? '') ??
                      DateTime.now(),
                  reviewerName: review['reviewerName'] as String? ?? '',
                  reviewerEmail: review['reviewerEmail'] as String? ?? '',
                );
              }
              return null; // Skip invalid review entries
            })
            .whereType<ProductReview>() // Filter out nulls
            .toList();
      }
      return []; // Default to empty list if not a list
    }

    // Safely parse meta object
    ProductMeta parseMeta(dynamic metaJson) {
      if (metaJson is Map<String, dynamic>) {
        return ProductMeta(
          createdAt:
              DateTime.tryParse(metaJson['createdAt'] as String? ?? '') ??
              DateTime.now(),
          updatedAt:
              DateTime.tryParse(metaJson['updatedAt'] as String? ?? '') ??
              DateTime.now(),
          barcode: metaJson['barcode'] as String? ?? '',
          qrCode: metaJson['qrCode'] as String? ?? '',
        );
      }
      // Provide default meta if null or invalid
      return ProductMeta(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        barcode: '',
        qrCode: '',
      );
    }

    return ProductModel(
      id: safeInt(json['id']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: safeDouble(json['price']), // Use safeDouble
      discountPercentage: safeDouble(
        json['discountPercentage'],
      ), // Use safeDouble
      rating:
          json['rating'] == null
              ? null
              : safeDouble(
                json['rating'],
              ), // Keep existing null check logic but use safeDouble
      stock: safeInt(json['stock']), // Use safeInt
      tags:
          json['tags'] is List
              ? List<String>.from(json['tags'].map((e) => e.toString()))
              : [], // Handle null or non-list
      brand: json['brand'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      weight: safeDouble(json['weight']), // Use safeDouble
      dimensions: parseDimensions(json['dimensions']), // Use safe parser
      warrantyInformation: json['warrantyInformation'] as String? ?? '',
      shippingInformation: json['shippingInformation'] as String? ?? '',
      availabilityStatus: json['availabilityStatus'] as String? ?? '',
      reviews: parseReviews(json['reviews']), // Use safe parser
      returnPolicy: json['returnPolicy'] as String? ?? '',
      minimumOrderQuantity: safeInt(
        json['minimumOrderQuantity'],
      ), // Use safeInt
      meta: parseMeta(json['meta']), // Use safe parser
      images:
          json['images'] is List
              ? List<String>.from(json['images'].map((e) => e.toString()))
              : [], // Handle null or non-list
      thumbnail: json['thumbnail'] as String? ?? '',
      isFavorite:
          json['isFavorite'] as bool? ?? false, // Keep existing null check
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

  static List<ProductModel> decodeList(String source) =>
      (jsonDecode(source) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();

  static String encodeList(List<ProductModel> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());
}
