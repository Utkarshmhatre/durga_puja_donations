import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_user.dart';

abstract class AdminAuthRepository {
  Future<AdminUser?> loadUser();
  Future<bool> isLoggedIn();
  Future<void> saveUserSession(AdminUser user);
  Future<void> clearSession();
  Future<List<AdminUser>> loadAllUsers();
  Future<void> saveAllUsers(List<AdminUser> users);
  Future<AdminUser?> authenticateUser(String username, String password);
  Future<void> ensureDefaultAdmin();
  Future<bool> changeUserPassword(
      String userId, String currentPassword, String newPassword);
  Future<AdminUser> createUser({
    required String username,
    required String email,
    required String password,
    required AdminRole role,
  });
  Future<void> updateUser(AdminUser user);
  Future<void> resetUserPassword(String userId, String newPassword);
  Future<void> deactivateUser(String userId);
  Future<void> reactivateUser(String userId);
}

class SharedPrefsAdminAuthRepository implements AdminAuthRepository {
  static const String _adminUserKey = 'admin_user';
  static const String _adminLoggedInKey = 'is_admin_logged_in';
  static const String _adminUsersKey = 'admin_users';
  static const String _adminSeededKey = 'admin_seeded';

  static String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt:$password');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<AdminUser?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_adminUserKey);
    if (userJson == null || userJson.isEmpty) {
      return null;
    }
    return AdminUser.fromJson(jsonDecode(userJson));
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adminLoggedInKey) ?? false;
  }

  @override
  Future<void> saveUserSession(AdminUser user) async {
    final prefs = await SharedPreferences.getInstance();
    // Don't persist passwordHash/salt in session
    final sessionUser = user.copyWith(passwordHash: '', salt: '');
    await prefs.setString(_adminUserKey, jsonEncode(sessionUser.toJson()));
    await prefs.setBool(_adminLoggedInKey, true);
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adminUserKey);
    await prefs.setBool(_adminLoggedInKey, false);
  }

  @override
  Future<List<AdminUser>> loadAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_adminUsersKey);
    if (usersJson == null || usersJson.isEmpty) return [];
    final List<dynamic> userList = jsonDecode(usersJson);
    return userList.map((u) => AdminUser.fromJson(u)).toList();
  }

  @override
  Future<void> saveAllUsers(List<AdminUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _adminUsersKey,
      jsonEncode(users.map((u) => u.toJson()).toList()),
    );
  }

  @override
  Future<void> ensureDefaultAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_adminSeededKey) == true) return;

    final users = await loadAllUsers();
    if (users.isEmpty) {
      final salt = _generateSalt();
      final hash = _hashPassword('admin123', salt);
      final defaultAdmin = AdminUser(
        id: '1',
        username: 'admin',
        email: 'admin@durgapuja.org',
        role: AdminRole.superAdmin,
        passwordHash: hash,
        salt: salt,
        createdAt: DateTime(2024, 1, 1),
        isActive: true,
      );
      await saveAllUsers([defaultAdmin]);
    }
    await prefs.setBool(_adminSeededKey, true);
  }

  @override
  Future<AdminUser?> authenticateUser(String username, String password) async {
    final users = await loadAllUsers();
    final user = users.where(
      (u) => u.username.toLowerCase() == username.toLowerCase() && u.isActive,
    );
    if (user.isEmpty) return null;

    final candidate = user.first;
    final hash = _hashPassword(password, candidate.salt);
    if (hash != candidate.passwordHash) return null;

    // Update lastLogin
    final updated = candidate.copyWith(lastLogin: DateTime.now());
    final idx = users.indexWhere((u) => u.id == updated.id);
    if (idx != -1) {
      users[idx] = updated;
      await saveAllUsers(users);
    }
    return updated;
  }

  @override
  Future<bool> changeUserPassword(
      String userId, String currentPassword, String newPassword) async {
    final users = await loadAllUsers();
    final idx = users.indexWhere((u) => u.id == userId);
    if (idx == -1) return false;

    final user = users[idx];
    final currentHash = _hashPassword(currentPassword, user.salt);
    if (currentHash != user.passwordHash) return false;

    final newSalt = _generateSalt();
    final newHash = _hashPassword(newPassword, newSalt);
    users[idx] = user.copyWith(passwordHash: newHash, salt: newSalt);
    await saveAllUsers(users);
    return true;
  }

  /// Creates a new admin user with hashed password.
  @override
  Future<AdminUser> createUser({
    required String username,
    required String email,
    required String password,
    required AdminRole role,
  }) async {
    final salt = _generateSalt();
    final hash = _hashPassword(password, salt);
    final users = await loadAllUsers();
    final newId = (users.length + 1).toString();
    final newUser = AdminUser(
      id: newId,
      username: username,
      email: email,
      role: role,
      passwordHash: hash,
      salt: salt,
      createdAt: DateTime.now(),
      isActive: true,
    );
    users.add(newUser);
    await saveAllUsers(users);
    return newUser;
  }

  /// Update user (non-password fields). Call changeUserPassword for password.
  @override
  Future<void> updateUser(AdminUser user) async {
    final users = await loadAllUsers();
    final idx = users.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      // Preserve existing password hash/salt
      users[idx] = user.copyWith(
        passwordHash: users[idx].passwordHash,
        salt: users[idx].salt,
      );
      await saveAllUsers(users);
    }
  }

  /// Reset a user's password (Super Admin action — no current password needed).
  @override
  Future<void> resetUserPassword(String userId, String newPassword) async {
    final users = await loadAllUsers();
    final idx = users.indexWhere((u) => u.id == userId);
    if (idx == -1) return;

    final newSalt = _generateSalt();
    final newHash = _hashPassword(newPassword, newSalt);
    users[idx] = users[idx].copyWith(passwordHash: newHash, salt: newSalt);
    await saveAllUsers(users);
  }

  /// Deactivate (soft-delete) a user.
  @override
  Future<void> deactivateUser(String userId) async {
    final users = await loadAllUsers();
    final idx = users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      users[idx] = users[idx].copyWith(isActive: false);
      await saveAllUsers(users);
    }
  }

  /// Reactivate a user.
  @override
  Future<void> reactivateUser(String userId) async {
    final users = await loadAllUsers();
    final idx = users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      users[idx] = users[idx].copyWith(isActive: true);
      await saveAllUsers(users);
    }
  }
}
