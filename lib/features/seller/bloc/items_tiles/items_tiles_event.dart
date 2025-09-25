part of 'items_tiles_bloc.dart';

sealed class ItemsTilesEvent extends Equatable {
  const ItemsTilesEvent();

  @override
  List<Object> get props => [];
}

final class SelectedItemsTiles extends ItemsTilesEvent {
  final Item item;

  const SelectedItemsTiles(this.item);

  @override
  List<Object> get props => [item];
}

final class GetInitialItemsTiles extends ItemsTilesEvent {
  const GetInitialItemsTiles();

  @override
  List<Object> get props => [];
}
