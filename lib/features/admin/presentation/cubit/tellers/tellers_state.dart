part of 'tellers_cubit.dart';

sealed class TellersState {
  const TellersState();
}

@Freezed(toJson: false)
class TellersInitial extends TellersState with _$TellersInitial {
  const TellersInitial();
}

@Freezed(toJson: false)
class TellersLoading extends TellersState with _$TellersLoading {
  const TellersLoading();
}

/// Loaded tellers for a given outlet. [selectedUserId] is the admin-session
/// selection (replaces the old module-level `user`/`initUser` globals).
@Freezed(toJson: false)
class TellersLoaded extends TellersState with _$TellersLoaded {
  const TellersLoaded(this.users, this.outletId, {this.selectedUserId});

  final List<AdminUser> users;
  final int outletId;
  final int? selectedUserId;
}

@Freezed(toJson: false)
class TellersError extends TellersState with _$TellersError {
  const TellersError(this.message);

  final String message;
}
