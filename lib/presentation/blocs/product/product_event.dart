abstract class ProductEvent {}

class LoadInitialProducts extends ProductEvent {}
class LoadMoreProducts extends ProductEvent {}
class ToggleFavorite extends ProductEvent {
  final int id;
  ToggleFavorite(this.id);
}