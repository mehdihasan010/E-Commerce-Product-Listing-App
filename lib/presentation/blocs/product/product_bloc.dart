import 'package:ecommerce_product_listing_app/domain/usecases/fetch_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProductsUseCase useCase;

  ProductBloc(this.useCase) : super(ProductState(products: [])) {
    on<LoadInitialProducts>(_onLoadInitial);
    on<LoadMoreProducts>(_onLoadMore);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadInitial(
      LoadInitialProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await useCase(page: 0);
      emit(state.copyWith(
        products: products,
        isLoading: false,
        currentPage: 1,
        hasReachedEnd: products.length < 10,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMore(
      LoadMoreProducts event, Emitter<ProductState> emit) async {
    if (state.isLoadingMore || state.hasReachedEnd) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final moreProducts = await useCase(page: state.currentPage);
      emit(state.copyWith(
        products: [...state.products, ...moreProducts],
        isLoadingMore: false,
        currentPage: state.currentPage + 1,
        hasReachedEnd: moreProducts.length < 10,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<ProductState> emit) {
    final updated = state.products.map((e) =>
        e.id == event.id ? e.copyWith(isFavorite: !e.isFavorite) : e).toList();
    emit(state.copyWith(products: updated));
  }
}