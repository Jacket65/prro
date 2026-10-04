part of 'outlets_cubit.dart';

sealed class OutletsState {
  const OutletsState();
}

/// Nothing loaded yet.
@Freezed(toJson: false)
class OutletsInitial extends OutletsState with _$OutletsInitial {
  const OutletsInitial();
}

/// Outlets are being fetched.
@Freezed(toJson: false)
class OutletsLoading extends OutletsState with _$OutletsLoading {
  const OutletsLoading();
}

/// Outlets loaded. [selectedOutletId] is the admin-session-scoped outlet
/// (replaces the old `getIt<int>()` outlet threading).
@Freezed(toJson: false)
class OutletsLoaded extends OutletsState with _$OutletsLoaded {
  const OutletsLoaded(this.outlets, {this.selectedOutletId});

  final List<RetailOutlet> outlets;
  final int? selectedOutletId;
}

/// A real failure (network, 401, …) while loading outlets.
@Freezed(toJson: false)
class OutletsError extends OutletsState with _$OutletsError {
  const OutletsError(this.message);

  final String message;
}
