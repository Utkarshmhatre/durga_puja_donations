import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/models/admin_user.dart';
import 'package:durga_puja_donations/repositories/admin_auth_repository.dart';
import 'package:durga_puja_donations/services/auth_service.dart';

/// In-memory auth repository for testing
class InMemoryAdminAuthRepository implements AdminAuthRepository {
  List<AdminUser> _users = [];
  AdminUser? _sessionUser;
  bool _loggedIn = false;
  bool _defaultAdminCreated = false;

  @override
  Future<void> ensureDefaultAdmin() async {
    if (_defaultAdminCreated) return;
    if (_users.isEmpty) {
      _users.add(AdminUser(
        id: '1',
        username: 'admin',
        email: 'admin@test.org',
        role: AdminRole.superAdmin,
        passwordHash: 'hash_admin123',
        salt: 'salt',
        createdAt: DateTime(2024, 1, 1),
        isActive: true,
      ));
    }
    _defaultAdminCreated = true;
  }

  @override
  Future<AdminUser?> authenticateUser(String username, String password) async {
    final match = _users.where(
      (u) => u.username.toLowerCase() == username.toLowerCase() && u.isActive,
    );
    if (match.isEmpty) return null;
    // Simple: accept password 'admin123' for default admin, or
    // '<hash_<password>>' format for any password
    final user = match.first;
    if (user.passwordHash == 'hash_$password') {
      return user.copyWith(lastLogin: DateTime.now());
    }
    return null;
  }

  @override
  Future<void> saveUserSession(AdminUser user) async {
    _sessionUser = user;
    _loggedIn = true;
  }

  @override
  Future<AdminUser?> loadUser() async => _sessionUser;

  @override
  Future<bool> isLoggedIn() async => _loggedIn;

  @override
  Future<void> clearSession() async {
    _sessionUser = null;
    _loggedIn = false;
  }

  @override
  Future<List<AdminUser>> loadAllUsers() async => List.from(_users);

  @override
  Future<void> saveAllUsers(List<AdminUser> users) async {
    _users = List.from(users);
  }

  @override
  Future<bool> changeUserPassword(
      String userId, String currentPassword, String newPassword) async {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx == -1) return false;
    final user = _users[idx];
    if (user.passwordHash != 'hash_$currentPassword') return false;
    _users[idx] = user.copyWith(passwordHash: 'hash_$newPassword');
    return true;
  }

  @override
  Future<AdminUser> createUser({
    required String username,
    required String email,
    required String password,
    required AdminRole role,
  }) async {
    final newUser = AdminUser(
      id: '${_users.length + 1}',
      username: username,
      email: email,
      role: role,
      passwordHash: 'hash_$password',
      salt: 'salt',
      createdAt: DateTime.now(),
      isActive: true,
    );
    _users.add(newUser);
    return newUser;
  }

  @override
  Future<void> updateUser(AdminUser user) async {
    final idx = _users.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      _users[idx] = user.copyWith(
        passwordHash: _users[idx].passwordHash,
        salt: _users[idx].salt,
      );
    }
  }

  @override
  Future<void> resetUserPassword(String userId, String newPassword) async {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(passwordHash: 'hash_$newPassword');
    }
  }

  @override
  Future<void> deactivateUser(String userId) async {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(isActive: false);
    }
  }

  @override
  Future<void> reactivateUser(String userId) async {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _users[idx] = _users[idx].copyWith(isActive: true);
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthService authService;
  late InMemoryAdminAuthRepository authRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    authRepo = InMemoryAdminAuthRepository();
    authService = AuthService(authRepository: authRepo);
    // Wait for _initialize to complete
    await Future.delayed(const Duration(milliseconds: 300));
  });

  group('AuthService - Initialization', () {
    test('starts with isLoading false after init', () {
      expect(authService.isLoading, false);
    });

    test('starts unauthenticated', () {
      expect(authService.isAuthenticated, false);
      expect(authService.currentUser, isNull);
    });

    test('ensures default admin exists', () async {
      final users = await authRepo.loadAllUsers();
      expect(users.length, 1);
      expect(users[0].username, 'admin');
    });
  });

  group('AuthService - Login', () {
    test('login with valid credentials succeeds', () async {
      final result = await authService.login('admin', 'admin123');

      expect(result.success, true);
      expect(result.message, 'Login successful');
      expect(authService.isAuthenticated, true);
      expect(authService.currentUser, isNotNull);
      expect(authService.currentUser!.username, 'admin');
    });

    test('login with wrong password fails', () async {
      final result = await authService.login('admin', 'wrongpassword');

      expect(result.success, false);
      expect(result.message, 'Invalid username or password');
      expect(authService.isAuthenticated, false);
    });

    test('login with unknown username fails', () async {
      final result = await authService.login('unknown', 'admin123');

      expect(result.success, false);
      expect(authService.isAuthenticated, false);
    });

    test('login is case-insensitive for username', () async {
      final result = await authService.login('Admin', 'admin123');
      expect(result.success, true);
    });
  });

  group('AuthService - Logout', () {
    test('logout clears state', () async {
      await authService.login('admin', 'admin123');
      expect(authService.isAuthenticated, true);

      await authService.logout();

      expect(authService.isAuthenticated, false);
      expect(authService.currentUser, isNull);
    });

    test('logout clears session in repository', () async {
      await authService.login('admin', 'admin123');
      await authService.logout();

      expect(await authRepo.isLoggedIn(), false);
      expect(await authRepo.loadUser(), isNull);
    });
  });

  group('AuthService - Change Password', () {
    test('changePassword succeeds with correct current password', () async {
      await authService.login('admin', 'admin123');
      final result =
          await authService.changePassword('admin123', 'newpassword');

      expect(result.success, true);
      expect(result.message, 'Password changed successfully');
    });

    test('changePassword fails with wrong current password', () async {
      await authService.login('admin', 'admin123');
      final result =
          await authService.changePassword('wrongpass', 'newpassword');

      expect(result.success, false);
      expect(result.message, 'Current password is incorrect');
    });

    test('changePassword fails when not authenticated', () async {
      final result =
          await authService.changePassword('admin123', 'newpassword');

      expect(result.success, false);
      expect(result.message, 'Not authenticated');
    });
  });

  group('AuthService - User Management', () {
    test('getAllUsers returns users list', () async {
      final users = await authService.getAllUsers();
      expect(users.length, 1);
    });

    test('createUser adds new user', () async {
      final user = await authService.createUser(
        username: 'moderator',
        email: 'mod@test.org',
        password: 'modpass',
        role: AdminRole.contentManager,
      );

      expect(user.username, 'moderator');
      expect(user.role, AdminRole.contentManager);

      final users = await authService.getAllUsers();
      expect(users.length, 2);
    });

    test('deactivateUser marks user inactive', () async {
      final user = await authService.createUser(
        username: 'toDeactivate',
        email: 'deact@test.org',
        password: 'pass',
        role: AdminRole.viewer,
      );

      await authService.deactivateUser(user.id);

      final users = await authService.getAllUsers();
      final deactivated = users.firstWhere((u) => u.id == user.id);
      expect(deactivated.isActive, false);
    });

    test('reactivateUser marks user active again', () async {
      final user = await authService.createUser(
        username: 'toReactivate',
        email: 'react@test.org',
        password: 'pass',
        role: AdminRole.viewer,
      );

      await authService.deactivateUser(user.id);
      await authService.reactivateUser(user.id);

      final users = await authService.getAllUsers();
      final reactivated = users.firstWhere((u) => u.id == user.id);
      expect(reactivated.isActive, true);
    });

    test('resetUserPassword allows login with new password', () async {
      await authService.resetUserPassword('1', 'resetpass');

      // Should be able to login with new password
      final result = await authService.login('admin', 'resetpass');
      expect(result.success, true);
    });

    test('deactivated user cannot login', () async {
      final user = await authService.createUser(
        username: 'blocked',
        email: 'blocked@test.org',
        password: 'blockpass',
        role: AdminRole.viewer,
      );

      await authService.deactivateUser(user.id);

      // Logout first if needed
      await authService.logout();

      final result = await authService.login('blocked', 'blockpass');
      expect(result.success, false);
    });
  });

  group('AuthService - Permissions', () {
    test('hasPermission returns false when not authenticated', () {
      expect(authService.hasPermission((role) => role.canManageUsers), false);
    });

    test('superAdmin has all permissions', () async {
      await authService.login('admin', 'admin123');

      expect(authService.hasPermission((role) => role.canManageUsers), true);
      expect(
          authService.hasPermission((role) => role.canManageDonations), true);
      expect(
          authService.hasPermission((role) => role.canManageContent), true);
      expect(authService.hasPermission((role) => role.canExportData), true);
    });

    test('notifyListeners called on login and logout', () async {
      int count = 0;
      authService.addListener(() => count++);

      await authService.login('admin', 'admin123');
      final afterLogin = count;
      expect(afterLogin, greaterThanOrEqualTo(1));

      await authService.logout();
      expect(count, greaterThan(afterLogin));
    });
  });
}
