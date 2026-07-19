import 'package:prro/data/api/models/shift.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart';

class MockShiftService implements ShiftServiceI {
  @override
  Future<ShiftResponse?> currentShift() async => const ShiftResponse(
    id: 1,
    outletId: 1,
    openedBy: 1,
    openedAt: '2024-01-01T00:00:00Z',
    cashStart: '0.00',
    status: 'open',
  );

  @override
  Future<ShiftResponse> openShift({
    required String idempotencyKey,
    String cashStart = '0.00',
  }) async => const ShiftResponse(
    id: 1,
    outletId: 1,
    openedBy: 1,
    openedAt: '2024-01-01T00:00:00Z',
    cashStart: '0.00',
    status: 'open',
  );

  @override
  Future<void> closeShift({
    required String cashEnd,
    required String idempotencyKey,
  }) async {}
}
