import 'package:flutter_test/flutter_test.dart';
import 'package:prro/features/admin/data/models/admin_user.dart';

void main() {
  group('AdminUser.fromJson name', () {
    test('joins first_name + last_name (the real wire shape)', () {
      final user = AdminUser.fromJson(const {
        'id': 3,
        'first_name': 'Іван',
        'last_name': 'Петренко',
        'login': 'cashier1',
        'role': 'cashier',
      });

      expect(user.name, 'Іван Петренко');
      expect(user.role, 'cashier');
    });

    test('trims a trailing space when last_name is absent', () {
      final user = AdminUser.fromJson(const {
        'id': 3,
        'first_name': 'Іван',
        'login': 'cashier1',
      });

      expect(user.name, 'Іван');
    });

    test('falls back to login when no name parts are present', () {
      final user = AdminUser.fromJson(const {
        'id': 3,
        'first_name': '',
        'last_name': '',
        'login': 'cashier1',
      });

      expect(user.name, 'cashier1');
    });

    test('still resolves the legacy name/username/full_name chain', () {
      expect(
        AdminUser.fromJson(const {'id': 1, 'name': 'Legacy Name'}).name,
        'Legacy Name',
      );
      expect(
        AdminUser.fromJson(const {'id': 1, 'username': 'legacy_user'}).name,
        'legacy_user',
      );
      expect(
        AdminUser.fromJson(const {'id': 1, 'full_name': 'Legacy Full'}).name,
        'Legacy Full',
      );
    });

    test('prefers the real name parts over a legacy key', () {
      final user = AdminUser.fromJson(const {
        'id': 1,
        'first_name': 'Іван',
        'last_name': 'Петренко',
        'name': 'stale',
      });

      expect(user.name, 'Іван Петренко');
    });
  });

  group('AdminUser.fromJson untouched surface', () {
    test('keeps phone, email and status available', () {
      final user = AdminUser.fromJson(const {
        'id': 1,
        'login': 'manager1',
        'phone': '+380000000000',
        'email': 'm@example.com',
        'status': 'active',
        'role': 'manager',
      });

      expect(user.phone, '+380000000000');
      expect(user.email, 'm@example.com');
      expect(user.status, DpsStatus.active);
      expect(user.role, 'manager');
    });

    test('an unrecognized status degrades to unknown instead of throwing', () {
      final user = AdminUser.fromJson(const {'id': 1, 'status': 'weird'});

      expect(user.status, DpsStatus.unknown);
    });
  });
}
