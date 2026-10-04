import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/domain/repositories/admin_catalog_repository_i.dart';

part 'product_detail_cubit.freezed.dart';
part 'product_detail_state.dart';

/// Variants of a product, plus the outlet's available ingredients (needed to
/// build a variant's recipe on creation). Drives the product detail screen.
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this._repository) : super(const ProductDetailLoading());
  final AdminCatalogRepositoryI _repository;

  Future<void> loadVariants({
    required int productId,
    required int outletId,
  }) async {
    emit(const ProductDetailLoading());
    try {
      // The variant list and the outlet's ingredient list are independent, so
      // they are fetched together: awaiting them one after the other made every
      // open of this screen (and every retry) pay two round-trips.
      final (variants, ingredients) = await (
        _repository.fetchVariants(productId: productId),
        _repository.fetchIngredients(outletId: outletId),
      ).wait;
      emit(ProductDetailLoaded(variants, ingredients: ingredients));
    } on Object catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> createVariant({
    required int productId,
    required String name,
    required int priceKopecks,
    required List<RecipeIngredient> ingredients,
    required String idempotencyKey,
  }) async {
    final previous = state is ProductDetailLoaded
        ? (state as ProductDetailLoaded).variants
        : const <AdminVariant>[];
    final availableIngredients = state is ProductDetailLoaded
        ? (state as ProductDetailLoaded).ingredients
        : const <AdminIngredient>[];
    emit(const ProductDetailLoading());
    try {
      final created = await _repository.createVariant(
        productId: productId,
        name: name,
        priceKopecks: priceKopecks,
        ingredients: ingredients,
        idempotencyKey: idempotencyKey,
      );
      emit(
        ProductDetailLoaded([
          ...previous,
          created,
        ], ingredients: availableIngredients),
      );
    } on Object catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  /// Restores the last loaded state after a failed create so the UI can show a
  /// SnackBar without dropping the existing items.
  void restoreVariants(ProductDetailLoaded previous) => emit(
    ProductDetailLoaded(previous.variants, ingredients: previous.ingredients),
  );
}
