import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:durga_puja_donations/repositories/hive_adapters.dart';
import 'package:durga_puja_donations/repositories/hive_admin_auth_repository.dart';
import 'package:durga_puja_donations/models/admin_user.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_auth_test_');
    Hive.init(tempDir.path);
    registerHiveAdapters();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUp(() async {
    if (Hive.isBoxOpen(HiveAdminAuthRepository.boxName)) {
      await Hive.box<AdminUser>(HiveAdminAuthRepository.boxName).clear();
    }
    if (Hive.isBoxOpen('admin_session')) {
      await Hive.box<dynamic>('admin_session').clear();
    }
  });

  group('HiveAdminAuthRepository', () {
    test('ensureDefaultAdmin creates admin user when empty', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();

      final users = await repo.loadAllUsers();
      expect(users.length, 1);
      expect(users[0].username, 'admin');
      expect(users[0].role, AdminRole.superAdmin);
    });

    test('ensureDefaultAdmin does not overwrite existing users', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      await repo.ensureDefaultAdmin(); // second call

      final users = await repo.loadAllUsers();
      expect(users.length, 1);
    });

    test('authenticateUser succeeds with correct credentials', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();

      final user = await repo.authenticateUser('admin', 'admin123');
      expect(user, isNotNull);
      expect(user!.username, 'admin');
      expect(user.lastLogin, isNotNull);
    });

    test('authenticateUser fails with wrong password', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();

      final user = await repo.authenticateUser('admin', 'wrong');
      expect(user, isNull);
    });

    test('authenticateUser fails with unknown username', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();

      final user = await repo.authenticateUser('nobody', 'admin123');
      expect(user, isNull);
    });

    test('createUser adds a new user', () async {
      final repo = HiveAdminAuthRepository();
      final user = await repo.createUser(
        username: 'manager1',
        email: 'mgr@puja.org',
        password: 'pass123',
        role: AdminRole.contentManager,
      );

      expect(user.username, 'manager1');
      expect(user.role, AdminRole.contentManager);

      // Verify can authenticate
      final auth = await repo.authenticateUser('manager1', 'pass123');
      expect(auth, isNotNull);
    });

    test('changeUserPassword works with correct current password', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      final users = await repo.loadAllUsers();

      final changed =
          await repo.changeUserPassword(users[0].id, 'admin123', 'newpass');
      expect(changed, true);

      // Old password fails
      final old = await repo.authenticateUser('admin', 'admin123');
      expect(old, isNull);

      // New password works
      final fresh = await repo.authenticateUser('admin', 'newpass');
      expect(fresh, isNotNull);
    });

    test('changeUserPassword fails with wrong current password', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      final users = await repo.loadAllUsers();

      final changed =
          await repo.changeUserPassword(users[0].id, 'wrongold', 'newpass');
      expect(changed, false);
    });

    test('deactivateUser prevents authentication', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      final users = await repo.loadAllUsers();

      await repo.deactivateUser(users[0].id);

      final auth = await repo.authenticateUser('admin', 'admin123');
      expect(auth, isNull);
    });

    test('reactivateUser restores authentication', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      final users = await repo.loadAllUsers();

      await repo.deactivateUser(users[0].id);
      await repo.reactivateUser(users[0].id);

      final auth = await repo.authenticateUser('admin', 'admin123');
      expect(auth, isNotNull);
    });

    test('session save and load roundtrip', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      final users = await repo.loadAllUsers();

      await repo.saveUserSession(users[0]);

      expect(await repo.isLoggedIn(), true);
      final loaded = await repo.loadUser();
      expect(loaded, isNotNull);
      expect(loaded!.username, 'admin');
      // Session should not contain password hash
      expect(loaded.passwordHash, '');
    });

    test('clearSession resets login state', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      final users = await repo.loadAllUsers();

      await repo.saveUserSession(users[0]);
      await repo.clearSession();

      expect(await repo.isLoggedIn(), false);
      expect(await repo.loadUser(), isNull);
    });

    test('resetUserPassword changes password without knowing the old one',
        () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      final users = await repo.loadAllUsers();

      await repo.resetUserPassword(users[0].id, 'resetpass');

      final auth = await repo.authenticateUser('admin', 'resetpass');
      expect(auth, isNotNull);
    });

    test('updateUser preserves password hash', () async {
      final repo = HiveAdminAuthRepository();
      await repo.ensureDefaultAdmin();
      final users = await repo.loadAllUsers();

      final updated = users[0].copyWith(
        email: 'new@email.org',
        role: AdminRole.admin,
      );
      await repo.updateUser(updated);

      // Email updated
      final reloaded = await repo.loadAllUsers();
      expect(reloaded[0].email, 'new@email.org');

      // Password still works
      final auth = await repo.authenticateUser('admin', 'admin123');
      expect(auth, isNotNull);
    });
  });
}
