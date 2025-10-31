part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final String username;
  LoadUser({required this.username});
  @override
  List<Object> get props => [username];
}

class ClearUser extends UserEvent {}
