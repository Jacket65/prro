import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';

part 'variant_detail_state.dart';

/// Recipe of a variant, plus the outlet's available ingredients for editing.
/// Drives the variant detail screen.
class VariantDetailCubit extends Cubit<VariantDetailState> {
  VariantDetailCubit(this._repository) : super(const VariantDetailLoading());
  final AdminCatalogRepositoryI _repository;

  Future<void> load({
    required int variantId,
    required int outletId,
  }) async {
    emit(const VariantDetailLoading());
    try {
      final recipe = await _repository.fetchRecipe(variantId: variantId);
      final ingredients = await _repository.fetchIngredients(
        outletId: outletId,
      );
      emit(VariantDetailLoaded(recipe, ingredients));
    } on Object catch (e) {
      emit(VariantDetailError(e.toString()));
    }
  }

  Future<void> replaceRecipe({
    required int variantId,
    required List<RecipeIngredient> ingredients,
  }) async {
    final current = state;
    final previousIngredients = current is VariantDetailLoaded
        ? current.ingredients
        : const <AdminIngredient>[];
    emit(const VariantDetailLoading());
    try {
      await _repository.replaceRecipe(
        variantId: variantId,
        ingredients: ingredients,
      );
      emit(VariantDetailLoaded(ingredients, previousIngredients));
    } on Object catch (e) {
      emit(VariantDetailError(e.toString()));
    }
  }

  /// Restores the last loaded recipe/ingredients after a failed save so the UI
  /// can show a SnackBar without dropping the existing data.
  void restore(
    List<RecipeIngredient> recipe,
    List<AdminIngredient> ingredients,
  ) => emit(VariantDetailLoaded(recipe, ingredients));
}
