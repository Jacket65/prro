part of 'items_tiles_bloc.dart';

sealed class ItemsTilesState extends Equatable {
  const ItemsTilesState();
  @override
  List<Object> get props => [];
}

final class ItemsTilesLoading extends ItemsTilesState {}

class ItemsTilesLoaded extends ItemsTilesState {
  final List<Item> items;
  final bool canGoBack;

  const ItemsTilesLoaded({required this.items, required this.canGoBack});

  @override
  List<Object> get props => [items, canGoBack];
}

final class ItemsTilesError extends ItemsTilesState {
  final String message;

  const ItemsTilesError({required this.message});

  @override
  List<Object> get props => [message];
}
