import 'package:ecommerce_product_listing_app/presentation/screens/home_screen.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class LoadMoreProducts extends ProductEvent {}

class ToggleFavorite extends ProductEvent {
  final int productId;
  ToggleFavorite(this.productId);
}

class UpdateSearchQuery extends ProductEvent {
  final String query;
  UpdateSearchQuery(this.query);
}

class UpdateSortOption extends ProductEvent {
  final SortOption sortOption;
  UpdateSortOption(this.sortOption);
}

class UpdateSearchActiveStatus extends ProductEvent {
  final bool isActive;
  UpdateSearchActiveStatus(this.isActive);
}
