part of 'category_detail_cubit.dart';

sealed class CategoryDetailState extends Equatable {
  const CategoryDetailState();

  @override
  List<Object?> get props => [];
}

final class CategoryDetailInitial extends CategoryDetailState {
  const CategoryDetailInitial();
}

final class CategoryDetailLoading extends CategoryDetailState {
  const CategoryDetailLoading();
}

/// Loaded products for a category.
final class CategoryDetailLoaded extends CategoryDetailState {
  const CategoryDetailLoaded(this.products);

  final List<AdminProduct> products;

  @override
  List<Object?> get props => [products];
}

final class CategoryDetailError extends CategoryDetailState {
  const CategoryDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
