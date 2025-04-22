import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_event.dart';
import 'scroll_event.dart';
import 'scroll_state.dart';

class ScrollBloc extends Bloc<ScrollEvent, ScrollState> {
  final ProductBloc productBloc;

  ScrollBloc({required this.productBloc})
    : super(ScrollState(scrollController: ScrollController())) {
    on<InitScrollController>(_onInitScrollController);
    on<ScrollPositionChanged>(_onScrollPositionChanged);
  }

  void _onInitScrollController(
    InitScrollController event,
    Emitter<ScrollState> emit,
  ) {
    state.scrollController.addListener(_checkScrollPosition);
  }

  void _checkScrollPosition() {
    final position = state.scrollController.position.pixels;
    final maxScrollExtent = state.scrollController.position.maxScrollExtent;

    add(
      ScrollPositionChanged(
        position: position,
        maxScrollExtent: maxScrollExtent,
      ),
    );
  }

  void _onScrollPositionChanged(
    ScrollPositionChanged event,
    Emitter<ScrollState> emit,
  ) {
    if (event.position >= event.maxScrollExtent - 100) {
      productBloc.add(LoadMoreProducts());
    }
  }

  @override
  Future<void> close() {
    state.scrollController.dispose();
    return super.close();
  }
}
