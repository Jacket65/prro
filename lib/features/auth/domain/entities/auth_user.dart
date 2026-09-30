import 'package:equatable/equatable.dart';

enum UserRole { seller, admin, manager }

class AuthUser extends Equatable {
  const AuthUser({required this.username, required this.role});

  final String username;
  final UserRole role;

  @override
  List<Object> get props => [username, role];
}
