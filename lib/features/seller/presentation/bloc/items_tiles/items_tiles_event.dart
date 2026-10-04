part of 'items_tiles_bloc.dart';

sealed class ItemsTilesEvent {
  const ItemsTilesEvent();
}

@Freezed(toJson: false)
class ItemsTilesStarted extends ItemsTilesEvent with _$ItemsTilesStarted {
  const ItemsTilesStarted();
}

@Freezed(toJson: false)
class ItemsTilesEnterCategory extends ItemsTilesEvent
    with _$ItemsTilesEnterCategory {
  const ItemsTilesEnterCategory(this.item);

  final Item item;
}

@Freezed(toJson: false)
class ItemsTilesBack extends ItemsTilesEvent with _$ItemsTilesBack {
  const ItemsTilesBack();
}
