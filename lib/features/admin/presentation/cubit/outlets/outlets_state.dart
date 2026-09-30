part of 'outlets_cubit.dart';

sealed class OutletsState extends Equatable {
  const OutletsState();

  @override
  List<Object?> get props => [];
}

/// Nothing loaded yet.
final class OutletsInitial extends OutletsState {
  const OutletsInitial();
}

/// Outlets are being fetched.
final class OutletsLoading extends OutletsState {
  const OutletsLoading();
}

/// Outlets loaded. [selectedOutletId] is the admin-session-scoped outlet
/// (replaces the old `getIt<int>()` outlet threading).
final class OutletsLoaded extends OutletsState {
  const OutletsLoaded(this.outlets, {this.selectedOutletId});

  final List<RetailOutlet> outlets;
  final int? selectedOutletId;

  @override
  List<Object?> get props => [outlets, selectedOutletId];
}

/// A real failure (network, 401, …) while loading outlets.
final class OutletsError extends OutletsState {
  const OutletsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
