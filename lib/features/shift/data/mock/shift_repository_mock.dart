import 'package:injectable/injectable.dart';
import 'package:prro/features/shift/domain/entities/shift.dart';
import 'package:prro/features/shift/domain/repositories/shift_repository_i.dart';

/// Mock-mode shift: always reports one already-open shift, so the seller lands
/// straight in the catalog instead of the "open shift" gate.
@Environment('mock')
@Singleton(as: ShiftRepositoryI)
class ShiftRepositoryMock implements ShiftRepositoryI {
  static const _openShift = ShiftResponse(
    id: 1,
    outletId: 1,
    openedBy: 1,
    openedAt: '2024-01-01T00:00:00Z',
    cashStart: '0.00',
    status: 'open',
  );

  @override
  Future<ShiftResponse?> currentShift() async => _openShift;

  @override
  Future<ShiftResponse> openShift({
    required String idempotencyKey,
    String cashStart = '0.00',
  }) async => _openShift;

  @override
  Future<void> closeShift({
    required String cashEnd,
    required String idempotencyKey,
  }) async {}
}
