part of 'items_tiles_bloc.dart';

sealed class ItemsTilesEvent extends Equatable {
  const ItemsTilesEvent();

  @override
  List<Object> get props => [];
}

class ItemsTilesStarted extends ItemsTilesEvent {}

class ItemsTilesEnterCategory extends ItemsTilesEvent {
  final Item item;

  const ItemsTilesEnterCategory(this.item);

  @override
  List<Object> get props => [item];
}

class ItemsTilesBack extends ItemsTilesEvent {}
