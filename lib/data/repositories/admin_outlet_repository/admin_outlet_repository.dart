import 'package:prro/data/api/models/admin/retail_outlet.dart';

/// Repository for admin-managed outlets (retail outlets).
// ignore: one_member_abstracts
abstract interface class AdminOutletRepositoryI {
  /// `GET /retail-outlets` → list of [RetailOutlet] (unwraps `{ "data": [...] }`).
  Future<List<RetailOutlet>> fetchOutlets();
}
