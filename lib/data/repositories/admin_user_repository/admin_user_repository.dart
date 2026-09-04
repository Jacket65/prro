import 'package:prro/data/api/models/admin/admin_user.dart';

/// Repository for admin-managed users (sellers / cashiers).
// ignore: one_member_abstracts
abstract interface class AdminUserRepositoryI {
  /// `GET /retail-outlets/{outletId}/users` → list of [AdminUser].
  Future<List<AdminUser>> fetchUsers({required int outletId});
}
