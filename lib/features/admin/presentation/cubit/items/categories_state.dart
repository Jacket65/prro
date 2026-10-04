part of 'categories_cubit.dart';

sealed class CategoriesState {
  const CategoriesState();
}

@Freezed(toJson: false)
class CategoriesInitial extends CategoriesState with _$CategoriesInitial {
  const CategoriesInitial();
}

@Freezed(toJson: false)
class CategoriesLoading extends CategoriesState with _$CategoriesLoading {
  const CategoriesLoading();
}

/// Loaded categories for an outlet. Mutations keep the list in state so the
/// grid updates without a full refetch.
@Freezed(toJson: false)
class CategoriesLoaded extends CategoriesState with _$CategoriesLoaded {
  const CategoriesLoaded(this.categories);

  final List<AdminCategory> categories;
}

@Freezed(toJson: false)
class CategoriesError extends CategoriesState with _$CategoriesError {
  const CategoriesError(this.message);

  final String message;
}
