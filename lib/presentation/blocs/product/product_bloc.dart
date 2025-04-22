import 'package:ecommerce_product_listing_app/domain/usecases/fetch_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProductsUseCase useCase;

  ProductBloc(this.useCase) : super(ProductState(products: [])) {
    on<LoadProducts>(_onLoadInitial);
    on<LoadMoreProducts>(_onLoadMore);
    on<ToggleFavorite>(_onToggleFavorite);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<UpdateSortOption>(_onUpdateSortOption);
  }

  Future<void> _onLoadInitial(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await useCase(page: 0);
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
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
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
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
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onUpdateSortOption(UpdateSortOption event, Emitter<ProductState> emit) {
    emit(state.copyWith(sortOption: event.sortOption));
  }
}
