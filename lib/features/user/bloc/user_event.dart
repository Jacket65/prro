part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {}

class ClearUserEvent extends UserEvent {}
