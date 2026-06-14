import 'dart:math';

final Random _rng = Random.secure();

/// Generates a random RFC-4122 version-4 UUID, e.g.
/// `9f1c2e3a-7b4d-4e6f-8a1b-2c3d4e5f6071`.
///
/// Used for `Idempotency-Key`: generate one per logical action (payment, shift
/// open/close) and reuse it for every retry of that request, including the
/// auto-retry after a token refresh.
String uuidV4() {
  final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 10xx
  String hex(int i) => bytes[i].toRadixString(16).padLeft(2, '0');
  final h = [for (var i = 0; i < 16; i++) hex(i)].join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}'
      '-${h.substring(16, 20)}-${h.substring(20)}';
}
