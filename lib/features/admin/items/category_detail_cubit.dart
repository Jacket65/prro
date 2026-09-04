import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';

part 'category_detail_state.dart';

/// Products within a category. Drives the category detail screen.
class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  CategoryDetailCubit(this._repository) : super(const CategoryDetailInitial());
  final AdminCatalogRepositoryI _repository;

  Future<void> loadProducts({required int categoryId}) async {
    emit(const CategoryDetailLoading());
    try {
      final products = await _repository.fetchProducts(categoryId: categoryId);
      emit(CategoryDetailLoaded(products));
    } on Object catch (e) {
      emit(CategoryDetailError(e.toString()));
    }
  }

  Future<void> createProduct({
    required int categoryId,
    required String name,
    required String idempotencyKey,
  }) async {
    final previous = state is CategoryDetailLoaded
        ? (state as CategoryDetailLoaded).products
        : const <AdminProduct>[];
    emit(const CategoryDetailLoading());
    try {
      final created = await _repository.createProduct(
        categoryId: categoryId,
        name: name,
        idempotencyKey: idempotencyKey,
      );
      emit(CategoryDetailLoaded([...previous, created]));
    } on Object catch (e) {
      emit(CategoryDetailError(e.toString()));
    }
  }

  /// Restores the last loaded list after a failed create so the UI can show a
  /// SnackBar without dropping the existing items.
  void restoreProducts(List<AdminProduct> products) =>
      emit(CategoryDetailLoaded(products));
}
