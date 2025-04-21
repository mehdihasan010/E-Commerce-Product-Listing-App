import 'package:ecommerce_product_listing_app/domain/entities/product_entity.dart';

class ProductState {
  final List<ProductEntity> products;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final bool hasReachedEnd;
  final String? error;

  ProductState({
    required this.products,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.hasReachedEnd = false,
    this.error,
  });

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    bool? hasReachedEnd,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: error,
    );
  }
}