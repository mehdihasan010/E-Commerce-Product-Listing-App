import 'package:ecommerce_product_listing_app/domain/entities/product_entity.dart';
import 'package:ecommerce_product_listing_app/presentation/screens/home_screen.dart';

class ProductState {
  final List<ProductEntity> products;
  final bool isLoading;
  final bool isLoadingMore;
  final String searchQuery;
  final SortOption sortOption;
  final String? error;
  final bool isSearchActive;
  final int searchTextSelectionStart;
  final int searchTextSelectionEnd;

  ProductState({
    required this.products,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.searchQuery = '',
    this.sortOption = SortOption.none,
    this.error,
    this.isSearchActive = false,
    this.searchTextSelectionStart = 0,
    this.searchTextSelectionEnd = 0,
  });

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    bool? isLoadingMore,
    String? searchQuery,
    SortOption? sortOption,
    String? error,
    bool? isSearchActive,
    int? searchTextSelectionStart,
    int? searchTextSelectionEnd,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      error: error,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      searchTextSelectionStart:
          searchTextSelectionStart ?? this.searchTextSelectionStart,
      searchTextSelectionEnd:
          searchTextSelectionEnd ?? this.searchTextSelectionEnd,
    );
  }
}
