part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({required this.username, required this.password});
  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

class LoginGetInitial extends LoginEvent {
  const LoginGetInitial();

  @override
  List<Object> get props => [];
}

class LoginCheckAutoLogin extends LoginEvent {
  const LoginCheckAutoLogin();

  @override
  List<Object> get props => [];
}
