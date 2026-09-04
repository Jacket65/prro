part of 'items_tiles_bloc.dart';

sealed class ItemsTilesState extends Equatable {
  const ItemsTilesState();
  @override
  List<Object> get props => [];
}

final class ItemsTilesLoading extends ItemsTilesState {}

class ItemsTilesLoaded extends ItemsTilesState {
  const ItemsTilesLoaded({required this.items, required this.canGoBack});
  final List<Item> items;
  final bool canGoBack;

  @override
  List<Object> get props => [items, canGoBack];
}

final class ItemsTilesError extends ItemsTilesState {
  const ItemsTilesError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
