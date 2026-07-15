part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  LoadUser({required this.username});
  final String username;
  @override
  List<Object> get props => [username];
}

class ClearUser extends UserEvent {}
