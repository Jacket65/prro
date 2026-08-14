part of 'items_tiles_bloc.dart';

sealed class ItemsTilesEvent extends Equatable {
  const ItemsTilesEvent();

  @override
  List<Object> get props => [];
}

class ItemsTilesStarted extends ItemsTilesEvent {}

class ItemsTilesEnterCategory extends ItemsTilesEvent {
  const ItemsTilesEnterCategory(this.item);
  final Item item;

  @override
  List<Object> get props => [item];
}

class ItemsTilesBack extends ItemsTilesEvent {}
