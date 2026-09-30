part of 'categories_cubit.dart';

sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

final class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

final class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

/// Loaded categories for an outlet. Mutations keep the list in state so the
/// grid updates without a full refetch.
final class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded(this.categories);

  final List<AdminCategory> categories;

  @override
  List<Object?> get props => [categories];
}

final class CategoriesError extends CategoriesState {
  const CategoriesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
