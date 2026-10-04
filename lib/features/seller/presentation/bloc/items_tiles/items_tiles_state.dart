part of 'items_tiles_bloc.dart';

sealed class ItemsTilesState {
  const ItemsTilesState();
}

@Freezed(toJson: false)
class ItemsTilesLoading extends ItemsTilesState with _$ItemsTilesLoading {
  const ItemsTilesLoading();
}

@Freezed(toJson: false)
class ItemsTilesLoaded extends ItemsTilesState with _$ItemsTilesLoaded {
  const ItemsTilesLoaded({required this.items, required this.canGoBack});

  final List<Item> items;
  final bool canGoBack;
}

@Freezed(toJson: false)
class ItemsTilesError extends ItemsTilesState with _$ItemsTilesError {
  const ItemsTilesError({required this.message});

  final String message;
}
