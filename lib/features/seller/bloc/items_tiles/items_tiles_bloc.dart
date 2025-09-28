import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/seller_item.dart';
import 'package:prro/data/repositories/repositories.dart';

part 'items_tiles_event.dart';
part 'items_tiles_state.dart';

class ItemsTilesBloc extends Bloc<ItemsTilesEvent, ItemsTilesState> {
  final ItemsRepositoryI _repository;
  final List<Category> _categoryStack = [];
  final Map<String, List<Item>> _cachedItems = {};

  ItemsTilesBloc({required ItemsRepositoryI itemsRepository})
    : _repository = itemsRepository,
      super(ItemsTilesLoading()) {
    on<ItemsTilesStarted>(_onStarted);
    on<ItemsTilesEnterCategory>(_onEnterCategory);
    on<ItemsTilesBack>(_onBack);
  }

  void _onStarted(
    ItemsTilesStarted event,
    Emitter<ItemsTilesState> emit,
  ) async {
    emit(ItemsTilesLoading());
    try {
      if (_cachedItems.containsKey('root')) {
        _categoryStack.clear();
        emit(ItemsTilesLoaded(items: _cachedItems['root']!, canGoBack: false));
      } else {
        final rootItems = await _repository.fetchItems();
        _cachedItems['root'] = rootItems;
        _categoryStack.clear();
        emit(ItemsTilesLoaded(items: rootItems, canGoBack: false));
      }
    } catch (e) {
      emit(ItemsTilesError(message: 'Не вдалося завантажити елементи.'));
    }
  }

  Future<void> _onEnterCategory(
    ItemsTilesEnterCategory event,
    Emitter<ItemsTilesState> emit,
  ) async {
    final item = event.item;
    if (item is! Category) {
      emit(ItemsTilesError(message: 'Це не категорія.'));
      return;
    }
    emit(ItemsTilesLoading());
    try {
      _categoryStack.add(item);
      final categoryKey = item.id;
      if (_cachedItems.containsKey(categoryKey)) {
        emit(
          ItemsTilesLoaded(items: _cachedItems[categoryKey]!, canGoBack: true),
        );
      } else {
        final categoryItems = await _repository.fetchItemsForCategory(item);
        _cachedItems[categoryKey] = categoryItems;
        emit(ItemsTilesLoaded(items: categoryItems, canGoBack: true));
      }
    } catch (e) {
      emit(ItemsTilesError(message: 'Не вдалося завантажити категорію.'));
    }
  }

  Future<void> _onBack(
    ItemsTilesBack event,
    Emitter<ItemsTilesState> emit,
  ) async {
    if (_categoryStack.isNotEmpty) {
      _categoryStack.removeLast();
      emit(ItemsTilesLoading());
      try {
        if (_categoryStack.isEmpty) {
          if (_cachedItems.containsKey('root')) {
            emit(
              ItemsTilesLoaded(items: _cachedItems['root']!, canGoBack: false),
            );
          } else {
            final parentCategory = _categoryStack.last;
            final categoryKey = parentCategory.id;

            if (_cachedItems.containsKey(categoryKey)) {
              emit(
                ItemsTilesLoaded(
                  items: _cachedItems[categoryKey]!,
                  canGoBack: true,
                ),
              );
            } else {
              final items = await _repository.fetchItemsForCategory(
                parentCategory,
              );
              _cachedItems[categoryKey] = items;
              emit(ItemsTilesLoaded(items: items, canGoBack: true));
            }
          }
        } else {
          final parentCategory = _categoryStack.last;
          final items = await _repository.fetchItemsForCategory(parentCategory);
          emit(ItemsTilesLoaded(items: items, canGoBack: true));
        }
      } catch (e) {
        emit(ItemsTilesError(message: 'Не вдалося повернутися назад.'));
      }
    }
  }
}
