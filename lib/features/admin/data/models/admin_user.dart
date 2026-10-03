import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/utils/json.dart';

part 'admin_user.freezed.dart';
part 'admin_user.g.dart';

/// Lifecycle status of an admin-managed user (seller / cashier).
///
/// The backend returns these as raw strings (`'registered'`, `'active'`, …).
/// Encoded as an enum so comparisons are type-safe instead of stringly-typed
/// `'Active'`/`'Inactive'`.
enum DpsStatus {
  registered,
  active,
  inactive,
  blocked,

  /// Any unrecognized value (incl. legacy `'Active'`/`'Inactive'`).
  unknown,
}

DpsStatus? _statusFromJson(Object? value) {
  final s = parseString(value).toLowerCase();

  return switch (s) {
    'registered' => DpsStatus.registered,
    'active' => DpsStatus.active,
    'inactive' => DpsStatus.inactive,
    'blocked' => DpsStatus.blocked,
    '' => null,
    _ => DpsStatus.unknown,
  };
}

/// Resolves the display name of an outlet user.
///
/// The backend sends the name split into `first_name` / `last_name`, with
/// `login` as the only always-present identifier — none of `name`/`username`/
/// `full_name` is ever sent. Those three stay as a legacy fallback chain so a
/// mock/older payload still renders.
String _nameFromJson(Map<dynamic, dynamic> json, String key) {
  final fullName =
      '${parseString(json['first_name'])} ${parseString(json['last_name'])}'
          .trim();
  return parseString(
    fullName,
    fallback: parseString(
      json['login'],
      fallback: parseString(
        json['name'],
        fallback: parseString(
          json['username'],
          fallback: parseString(json['full_name']),
        ),
      ),
    ),
  );
}

/// A user (seller / cashier) belonging to a retail outlet.
///
/// Mirrors `GET /retail-outlets/{id}/users` payloads wrapped in
/// `{ "data": [...] }`.
@freezed
abstract class AdminUser with _$AdminUser {
  const factory AdminUser({
    @JsonKey(fromJson: parseInt) required int id,

    @JsonKey(readValue: _nameFromJson) required String name,

    @JsonKey(fromJson: parseNullableString) String? phone,

    @JsonKey(fromJson: parseNullableString) String? email,

    @JsonKey(fromJson: _statusFromJson) DpsStatus? status,

    @JsonKey(fromJson: parseNullableString) String? role,
  }) = _AdminUser;

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);
}
