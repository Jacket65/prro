part of 'variant_detail_cubit.dart';

sealed class VariantDetailState {
  const VariantDetailState();
}

@Freezed(toJson: false)
class VariantDetailLoading extends VariantDetailState
    with _$VariantDetailLoading {
  const VariantDetailLoading();
}

@Freezed(toJson: false)
class VariantDetailLoaded extends VariantDetailState
    with _$VariantDetailLoaded {
  const VariantDetailLoaded(this.recipe, this.ingredients);

  final List<RecipeIngredient> recipe;
  final List<AdminIngredient> ingredients;
}

@Freezed(toJson: false)
class VariantDetailError extends VariantDetailState with _$VariantDetailError {
  const VariantDetailError(this.message);

  final String message;
}
