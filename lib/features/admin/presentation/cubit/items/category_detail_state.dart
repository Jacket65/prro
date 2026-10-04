part of 'category_detail_cubit.dart';

sealed class CategoryDetailState {
  const CategoryDetailState();
}

@Freezed(toJson: false)
class CategoryDetailInitial extends CategoryDetailState
    with _$CategoryDetailInitial {
  const CategoryDetailInitial();
}

@Freezed(toJson: false)
class CategoryDetailLoading extends CategoryDetailState
    with _$CategoryDetailLoading {
  const CategoryDetailLoading();
}

/// Loaded products for a category.
@Freezed(toJson: false)
class CategoryDetailLoaded extends CategoryDetailState
    with _$CategoryDetailLoaded {
  const CategoryDetailLoaded(this.products);

  final List<AdminProduct> products;
}

@Freezed(toJson: false)
class CategoryDetailError extends CategoryDetailState
    with _$CategoryDetailError {
  const CategoryDetailError(this.message);

  final String message;
}
