part of 'catalog_search_cubit.dart';

sealed class CatalogSearchState {
  const CatalogSearchState();
}

/// No active search — show the normal catalog.
@Freezed(toJson: false)
class CatalogSearchIdle extends CatalogSearchState with _$CatalogSearchIdle {
  const CatalogSearchIdle();
}

@Freezed(toJson: false)
class CatalogSearchLoading extends CatalogSearchState
    with _$CatalogSearchLoading {
  const CatalogSearchLoading();
}

@Freezed(toJson: false)
class CatalogSearchResults extends CatalogSearchState
    with _$CatalogSearchResults {
  const CatalogSearchResults(this.items);

  final List<Item> items;
}

@Freezed(toJson: false)
class CatalogSearchError extends CatalogSearchState
    with _$CatalogSearchError {
  const CatalogSearchError(this.message);

  final String message;
}
