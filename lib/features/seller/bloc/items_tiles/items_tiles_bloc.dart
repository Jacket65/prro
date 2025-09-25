import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/seller_item.dart';

part 'items_tiles_event.dart';
part 'items_tiles_state.dart';

class ItemsTilesBloc extends Bloc<ItemsTilesEvent, ItemsTilesState> {
  ItemsTilesBloc() : super(ItemsTilesInitial()) {
    on<SelectedItemsTiles>((event, emit) {
      emit(ItemsTilesSelected(event.item));
    });

    on<GetInitialItemsTiles>((event, emit) {
      emit(ItemsTilesInitial());
    });
  }
}
