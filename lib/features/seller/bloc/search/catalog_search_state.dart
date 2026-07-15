part of 'catalog_search_cubit.dart';

sealed class CatalogSearchState extends Equatable {
  const CatalogSearchState();

  @override
  List<Object> get props => [];
}

/// No active search — show the normal catalog.
final class CatalogSearchIdle extends CatalogSearchState {
  const CatalogSearchIdle();
}

final class CatalogSearchLoading extends CatalogSearchState {
  const CatalogSearchLoading();
}

final class CatalogSearchResults extends CatalogSearchState {
  const CatalogSearchResults(this.items);
  final List<Item> items;

  @override
  List<Object> get props => [items];
}

final class CatalogSearchError extends CatalogSearchState {
  const CatalogSearchError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
