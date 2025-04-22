import 'dart:io';

import 'package:ecommerce_product_listing_app/core/services/image_cache_service.dart';
import 'package:ecommerce_product_listing_app/domain/usecases/fetch_products_usecase.dart';
import 'package:ecommerce_product_listing_app/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProductsUseCase useCase;
  final ImageCacheService? imageCacheService;

  ProductBloc(this.useCase, {this.imageCacheService})
    : super(ProductState(products: [])) {
    on<LoadProducts>(_onLoadInitial);
    on<LoadMoreProducts>(_onLoadMore);
    on<ToggleFavorite>(_onToggleFavorite);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<UpdateSortOption>(_onUpdateSortOption);
    on<UpdateSearchActiveStatus>(_onUpdateSearchActiveStatus);
    on<UpdateSearchTextSelection>(_onUpdateSearchTextSelection);
  }

  Future<void> _onLoadInitial(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await useCase(page: 0);
      emit(state.copyWith(products: products, isLoading: false));

      // Pre-cache product images for offline use
      if (imageCacheService != null) {
        final imageUrls = products.map((product) => product.image).toList();
        imageCacheService!.precacheImages(imageUrls);
      }
    } catch (e) {
      // Set specific error for network issues
      String errorMessage = e.toString();
      if (e is SocketException ||
          e is HttpException ||
          e.toString().contains('network')) {
        errorMessage = 'Network error: Please check your internet connection';
      }
      emit(state.copyWith(isLoading: false, error: errorMessage));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final moreProducts = await useCase(page: state.products.length ~/ 10);
      emit(
        state.copyWith(
          products: [...state.products, ...moreProducts],
          isLoadingMore: false,
        ),
      );

      // Pre-cache new product images for offline use
      if (imageCacheService != null) {
        final imageUrls = moreProducts.map((product) => product.image).toList();
        imageCacheService!.precacheImages(imageUrls);
      }
    } catch (e) {
      // Set specific error for network issues
      String errorMessage = e.toString();
      if (e is SocketException ||
          e is HttpException ||
          e.toString().contains('network')) {
        errorMessage = 'Network error: Cannot load more products';
      }
      emit(state.copyWith(isLoadingMore: false, error: errorMessage));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<ProductState> emit) {
    final updated =
        state.products
            .map(
              (p) =>
                  p.id == event.productId
                      ? p.copyWith(isFavorite: !p.isFavorite)
                      : p,
            )
            .toList();
    emit(state.copyWith(products: updated));
  }

  void _onUpdateSearchQuery(
    UpdateSearchQuery event,
    Emitter<ProductState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        // Reset the selection to end of new query
        searchTextSelectionStart: event.query.length,
        searchTextSelectionEnd: event.query.length,
      ),
    );
  }

  void _onUpdateSortOption(UpdateSortOption event, Emitter<ProductState> emit) {
    emit(state.copyWith(sortOption: event.sortOption));
  }

  void _onUpdateSearchActiveStatus(
    UpdateSearchActiveStatus event,
    Emitter<ProductState> emit,
  ) {
    // When search becomes inactive, reset sort option to none
    if (state.isSearchActive && !event.isActive) {
      emit(
        state.copyWith(
          isSearchActive: event.isActive,
          sortOption: SortOption.none,
        ),
      );
    } else {
      emit(state.copyWith(isSearchActive: event.isActive));
    }
  }

  void _onUpdateSearchTextSelection(
    UpdateSearchTextSelection event,
    Emitter<ProductState> emit,
  ) {
    emit(
      state.copyWith(
        searchTextSelectionStart: event.start,
        searchTextSelectionEnd: event.end,
      ),
    );
  }
}
