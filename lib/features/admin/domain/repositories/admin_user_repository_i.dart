import 'package:prro/features/admin/data/models/admin_user.dart';

/// Repository for admin-managed users (sellers / cashiers).
abstract interface class AdminUserRepositoryI {
  /// `GET /retail-outlets/{outletId}/users` → list of [AdminUser].
  Future<List<AdminUser>> fetchUsers({required int outletId});
}
