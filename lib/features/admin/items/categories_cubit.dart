import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';

part 'categories_state.dart';

/// Catalog categories (outlet-scoped) with CRUD. Drives the items tab grid.
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._repository) : super(const CategoriesInitial());
  final AdminCatalogRepositoryI _repository;

  Future<void> loadCategories({required int outletId}) async {
    emit(const CategoriesLoading());
    try {
      final categories = await _repository.fetchCategories(outletId: outletId);
      emit(CategoriesLoaded(categories));
    } on Object catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> createCategory({
    required int outletId,
    required String name,
  }) async {
    final previous = state is CategoriesLoaded
        ? (state as CategoriesLoaded).categories
        : const <AdminCategory>[];
    emit(const CategoriesLoading());
    try {
      final created = await _repository.createCategory(
        outletId: outletId,
        name: name,
        idempotencyKey: uuidV4(),
      );
      emit(CategoriesLoaded([...previous, created]));
    } on Object catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> renameCategory({required int id, required String name}) async {
    final previous = state is CategoriesLoaded
        ? (state as CategoriesLoaded).categories
        : const <AdminCategory>[];
    emit(const CategoriesLoading());
    try {
      final updated = await _repository.updateCategory(id: id, name: name);
      emit(
        CategoriesLoaded([
          for (final c in previous)
            if (c.id == id) updated else c,
        ]),
      );
    } on Object catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> deleteCategory({required int id}) async {
    final previous = state is CategoriesLoaded
        ? (state as CategoriesLoaded).categories
        : const <AdminCategory>[];
    emit(const CategoriesLoading());
    try {
      await _repository.deleteCategory(id: id);
      emit(
        CategoriesLoaded(previous.where((c) => c.id != id).toList()),
      );
    } on Object catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
