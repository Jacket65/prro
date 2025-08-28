part of 'items_tiles_bloc.dart';

sealed class ItemsTilesState extends Equatable {
  const ItemsTilesState();
  @override
  List<Object> get props => [];
}

final class ItemsTilesInitial extends ItemsTilesState {
  const ItemsTilesInitial();

  @override
  List<Object> get props => [];
}

final class ItemsTilesSelected extends ItemsTilesState {
  final Item item;

  const ItemsTilesSelected(this.item);

  @override
  List<Object> get props => [item];
}
