import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// The signed-in user, as the session layer knows them.
///
/// The role enum mirrors the backend vocabulary (`admin` / `manager` /
/// `cashier`); see `auth_repository.dart` for the wire mapping.
enum UserRole { cashier, admin, manager }

@Freezed(toJson: false)
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String username,
    required UserRole role,
  }) = _AuthUser;
}
