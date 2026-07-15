import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/items_repository/items_repo_i.dart';

part 'catalog_search_state.dart';

/// Drives the catalog search overlay. Cubit methods aren't queued, so a new
/// [search] immediately cancels the previous request's [CancelToken] (the last
/// query wins; stale results never show).
class CatalogSearchCubit extends Cubit<CatalogSearchState> {

  CatalogSearchCubit(this._repository) : super(const CatalogSearchIdle());
  final ItemsRepositoryI _repository;
  CancelToken? _cancel;

  Future<void> search(String query) async {
    final q = query.trim();
    // Abort whatever is in flight before deciding what to do next.
    _cancel?.cancel('superseded');
    if (q.isEmpty) {
      _cancel = null;
      emit(const CatalogSearchIdle());
      return;
    }
    final cancel = _cancel = CancelToken();
    emit(const CatalogSearchLoading());
    try {
      final items = await _repository.searchProducts(
        query: q,
        cancelToken: cancel,
      );
      if (cancel.isCancelled) return; // superseded mid-flight
      emit(CatalogSearchResults(items));
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return; // superseded — ignore
      emit(const CatalogSearchError('Не вдалося виконати пошук.'));
    } catch (_) {
      emit(const CatalogSearchError('Не вдалося виконати пошук.'));
    }
  }

  /// Clears search and returns to the normal catalog.
  void clear() {
    _cancel?.cancel('cleared');
    _cancel = null;
    emit(const CatalogSearchIdle());
  }

  @override
  Future<void> close() {
    _cancel?.cancel('closed');
    return super.close();
  }
}
