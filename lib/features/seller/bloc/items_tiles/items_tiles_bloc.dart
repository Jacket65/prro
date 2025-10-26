import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/seller_item.dart';
import 'package:prro/data/repositories/repositories.dart';

part 'items_tiles_event.dart';
part 'items_tiles_state.dart';

class ItemsTilesBloc extends Bloc<ItemsTilesEvent, ItemsTilesState> {
  final ItemsRepositoryI _repository;
  final List<Category> _categoryStack = [];
  final Map<int?, List<Item>> _cachedItems = {};

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
    _categoryStack.clear();
    _cachedItems.clear();
    await _loadCategoryItems(null, emit, canGoBack: false);
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
    _categoryStack.add(item);
    await _loadCategoryItems(item.id, emit, canGoBack: true);
  }

  Future<void> _onBack(
    ItemsTilesBack event,
    Emitter<ItemsTilesState> emit,
  ) async {
    if (_categoryStack.isEmpty) return;
    _categoryStack.removeLast();
    final parentCategoryId = _categoryStack.isNotEmpty
        ? _categoryStack.last.id
        : null;
    final canGoBack = _categoryStack.isNotEmpty;

    await _loadCategoryItems(parentCategoryId, emit, canGoBack: canGoBack);
  }

  Future<void> _loadCategoryItems(
    int? categoryId,
    Emitter<ItemsTilesState> emit, {
    required bool canGoBack,
  }) async {
    emit(ItemsTilesLoading());

    try {
      if (_cachedItems.containsKey(categoryId)) {
        emit(
          ItemsTilesLoaded(
            items: _cachedItems[categoryId]!,
            canGoBack: canGoBack,
          ),
        );
      } else {
        final items = categoryId == null
            ? await _repository.getItemsCategory()
            : await _repository.getItems(categoryId);

        _cachedItems[categoryId] = items;
        emit(ItemsTilesLoaded(items: items, canGoBack: canGoBack));
      }
    } catch (e) {
      final message = categoryId == null
          ? 'Не вдалося завантажити елементи.'
          : 'Не вдалося завантажити категорію.';
      emit(ItemsTilesError(message: message));
    }
  }
}
