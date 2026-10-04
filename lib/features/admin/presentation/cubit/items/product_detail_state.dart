part of 'product_detail_cubit.dart';

sealed class ProductDetailState {
  const ProductDetailState();
}

@Freezed(toJson: false)
class ProductDetailLoading extends ProductDetailState
    with _$ProductDetailLoading {
  const ProductDetailLoading();
}

@Freezed(toJson: false)
class ProductDetailLoaded extends ProductDetailState
    with _$ProductDetailLoaded {
  const ProductDetailLoaded(this.variants, {this.ingredients = const []});

  final List<AdminVariant> variants;

  /// The outlet's available ingredients, used to build a new variant's recipe.
  final List<AdminIngredient> ingredients;
}

@Freezed(toJson: false)
class ProductDetailError extends ProductDetailState with _$ProductDetailError {
  const ProductDetailError(this.message);

  final String message;
}
