part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {

  UserLoaded(this.username);
  final String username;

  @override
  List<Object?> get props => [username];
}

class UserError extends UserState {

  UserError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
