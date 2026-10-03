part of 'product_detail_cubit.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

final class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded(this.variants, {this.ingredients = const []});

  final List<AdminVariant> variants;

  /// The outlet's available ingredients, used to build a new variant's recipe.
  final List<AdminIngredient> ingredients;

  @override
  List<Object?> get props => [variants, ingredients];
}

final class ProductDetailError extends ProductDetailState {
  const ProductDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
