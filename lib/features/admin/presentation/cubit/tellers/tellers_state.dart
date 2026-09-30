part of 'tellers_cubit.dart';

sealed class TellersState extends Equatable {
  const TellersState();

  @override
  List<Object?> get props => [];
}

final class TellersInitial extends TellersState {
  const TellersInitial();
}

final class TellersLoading extends TellersState {
  const TellersLoading();
}

/// Loaded tellers for a given outlet. [selectedUserId] is the admin-session
/// selection (replaces the old module-level `user`/`initUser` globals).
final class TellersLoaded extends TellersState {
  const TellersLoaded(this.users, this.outletId, {this.selectedUserId});

  final List<AdminUser> users;
  final int outletId;
  final int? selectedUserId;

  @override
  List<Object?> get props => [users, outletId, selectedUserId];
}

final class TellersError extends TellersState {
  const TellersError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
