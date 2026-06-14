import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/repositories.dart';

part 'items_tiles_event.dart';
part 'items_tiles_state.dart';

/// Two-level navigation: categories → abstract products.
/// Variants are shown in a modal dialog spawned from the [ProductGroup] tile,
/// so they are NOT part of the navigation stack.
///   - empty stack:        showing categories
///   - 1 entry (category): showing abstract products
class ItemsTilesBloc extends Bloc<ItemsTilesEvent, ItemsTilesState> {
  final ItemsRepositoryI _repository;
  final List<Category> _stack = [];

  ItemsTilesBloc({required ItemsRepositoryI itemsRepository})
    : _repository = itemsRepository,
      super(ItemsTilesLoading()) {
    on<ItemsTilesStarted>(_onStarted);
    on<ItemsTilesEnterCategory>(_onEnterCategory);
    on<ItemsTilesBack>(_onBack);
  }

  Future<void> _onStarted(
    ItemsTilesStarted event,
    Emitter<ItemsTilesState> emit,
  ) async {
    _stack.clear();
    await _loadForCurrentDepth(emit);
  }

  Future<void> _onEnterCategory(
    ItemsTilesEnterCategory event,
    Emitter<ItemsTilesState> emit,
  ) async {
    final item = event.item;
    if (item is! Category) {
      // ProductGroup and Product are leaves at this level.
      return;
    }
    if (_stack.isNotEmpty) {
      // Already inside a category — refuse to go deeper.
      return;
    }
    _stack.add(item);
    await _loadForCurrentDepth(emit);
  }

  Future<void> _onBack(
    ItemsTilesBack event,
    Emitter<ItemsTilesState> emit,
  ) async {
    if (_stack.isEmpty) return;
    _stack.removeLast();
    await _loadForCurrentDepth(emit);
  }

  Future<void> _loadForCurrentDepth(Emitter<ItemsTilesState> emit) async {
    emit(ItemsTilesLoading());
    try {
      final List<Item> items;
      switch (_stack.length) {
        case 0:
          items = await _repository.getCategories();
        case 1:
          items = await _repository.getProducts(_stack.last.id);
        default:
          items = const [];
      }
      emit(ItemsTilesLoaded(items: items, canGoBack: _stack.isNotEmpty));
    } catch (_) {
      final message = _stack.isEmpty
          ? 'Не вдалося завантажити категорії.'
          : 'Не вдалося завантажити товари.';
      emit(ItemsTilesError(message: message));
    }
  }
}
