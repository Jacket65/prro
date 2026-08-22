import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';

part 'product_detail_state.dart';

/// Variants of a product. Drives the product detail screen.
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this._repository) : super(const ProductDetailLoading());
  final AdminCatalogRepositoryI _repository;

  Future<void> loadVariants({required int productId}) async {
    emit(const ProductDetailLoading());
    try {
      final variants = await _repository.fetchVariants(productId: productId);
      emit(ProductDetailLoaded(variants));
    } on Object catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> createVariant({
    required int productId,
    required String name,
    required int priceKopecks,
    required String idempotencyKey,
  }) async {
    final previous = state is ProductDetailLoaded
        ? (state as ProductDetailLoaded).variants
        : const <AdminVariant>[];
    emit(const ProductDetailLoading());
    try {
      final created = await _repository.createVariant(
        productId: productId,
        name: name,
        priceKopecks: priceKopecks,
        ingredients: const [],
        idempotencyKey: idempotencyKey,
      );
      emit(ProductDetailLoaded([...previous, created]));
    } on Object catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  /// Restores the last loaded list after a failed create so the UI can show a
  /// SnackBar without dropping the existing items.
  void restoreVariants(List<AdminVariant> variants) =>
      emit(ProductDetailLoaded(variants));
}
