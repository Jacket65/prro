part of 'variant_detail_cubit.dart';

sealed class VariantDetailState extends Equatable {
  const VariantDetailState();

  @override
  List<Object?> get props => [];
}

final class VariantDetailLoading extends VariantDetailState {
  const VariantDetailLoading();
}

final class VariantDetailLoaded extends VariantDetailState {
  const VariantDetailLoaded(this.recipe, this.ingredients);

  final List<RecipeIngredient> recipe;
  final List<AdminIngredient> ingredients;

  @override
  List<Object?> get props => [recipe, ingredients];
}

final class VariantDetailError extends VariantDetailState {
  const VariantDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
