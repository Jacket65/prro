import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/domain/repositories/admin_catalog_repository_i.dart';

part 'variant_detail_cubit.freezed.dart';
part 'variant_detail_state.dart';

/// Recipe of a variant, plus the outlet's available ingredients for editing.
/// Drives the variant detail screen.
class VariantDetailCubit extends Cubit<VariantDetailState> {
  VariantDetailCubit(this._repository) : super(const VariantDetailLoading());
  final AdminCatalogRepositoryI _repository;

  Future<void> load({required int variantId, required int outletId}) async {
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

  /// Saves the edited recipe, then re-reads what the server actually holds.
  ///
  /// The re-read is the point: `PUT /variants/{id}/recipe` is a no-op stub on
  /// the backend, so emitting the locally edited list here would show the
  /// admin a phantom recipe that silently reverts on the next reload. The call
  /// and the optimistic loading state stay — once the backend implements the
  /// write, the re-read simply returns the same list.
  ///
  /// The re-read runs even when the write failed, because a stub that returns
  /// success is exactly the case where the difference matters: the admin sees
  /// the unchanged server state immediately instead of believing the edit
  /// landed. If the re-read itself fails the state goes to
  /// [VariantDetailError], which the screen already handles (restore + retry).
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
      // Authoritative state comes from the server, never from the editor.
      final saved = await _repository.fetchRecipe(variantId: variantId);
      emit(VariantDetailLoaded(saved, previousIngredients));
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
