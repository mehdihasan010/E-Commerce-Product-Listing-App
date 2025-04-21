class ProductEntity {
  final int id;
  final String title;
  final String description;
  final String image;
  final double price;
  final double rating;
  final int ratingCount;
  final bool isFavorite;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.ratingCount,
    this.isFavorite = false,
  });

  ProductEntity copyWith({
    int? id,
    String? title,
    String? description,
    String? image,
    double? price,
    double? rating,
    int? ratingCount,
    bool? isFavorite,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
