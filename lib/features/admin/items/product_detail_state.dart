part of 'product_detail_cubit.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

final class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded(this.variants);

  final List<AdminVariant> variants;

  @override
  List<Object?> get props => [variants];
}

final class ProductDetailError extends ProductDetailState {
  const ProductDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
