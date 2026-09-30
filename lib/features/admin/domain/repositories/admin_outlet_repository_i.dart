import 'package:prro/features/admin/data/models/retail_outlet.dart';

/// Repository for admin-managed outlets (retail outlets).
abstract interface class AdminOutletRepositoryI {
  /// `GET /retail-outlets` → list of [RetailOutlet] (unwraps `{ "data": [...] }`).
  Future<List<RetailOutlet>> fetchOutlets();
}
