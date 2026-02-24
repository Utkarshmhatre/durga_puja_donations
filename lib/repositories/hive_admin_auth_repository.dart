import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import '../models/admin_user.dart';
import 'admin_auth_repository.dart';

class HiveAdminAuthRepository implements AdminAuthRepository {
  static const String boxName = 'admin_auth';
  static const String _sessionBoxName = 'admin_session';

  Box<AdminUser>? _box;
  Box<dynamic>? _sessionBox;

  Future<Box<AdminUser>> get _openBox async {
    _box ??= await Hive.openBox<AdminUser>(boxName);
    return _box!;
  }

  Future<Box<dynamic>> get _openSessionBox async {
    _sessionBox ??= await Hive.openBox<dynamic>(_sessionBoxName);
    return _sessionBox!;
  }

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
    final session = await _openSessionBox;
    final userJson = session.get('current_user');
    if (userJson == null) return null;
    return AdminUser.fromJson(Map<String, dynamic>.from(userJson));
  }

  @override
  Future<bool> isLoggedIn() async {
    final session = await _openSessionBox;
    return session.get('is_logged_in', defaultValue: false) == true;
  }

  @override
  Future<void> saveUserSession(AdminUser user) async {
    final session = await _openSessionBox;
    final sessionUser = user.copyWith(passwordHash: '', salt: '');
    await session.put('current_user', sessionUser.toJson());
    await session.put('is_logged_in', true);
  }

  @override
  Future<void> clearSession() async {
    final session = await _openSessionBox;
    await session.delete('current_user');
    await session.put('is_logged_in', false);
  }

  @override
  Future<List<AdminUser>> loadAllUsers() async {
    final box = await _openBox;
    return box.values.toList();
  }

  @override
  Future<void> saveAllUsers(List<AdminUser> users) async {
    final box = await _openBox;
    await box.clear();
    for (final user in users) {
      await box.put(user.id, user);
    }
  }

  @override
  Future<void> ensureDefaultAdmin() async {
    final box = await _openBox;
    if (box.isNotEmpty) return;

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
    await box.put(defaultAdmin.id, defaultAdmin);
  }

  @override
  Future<AdminUser?> authenticateUser(String username, String password) async {
    final box = await _openBox;
    final users = box.values.toList();
    final matches = users.where(
      (u) => u.username.toLowerCase() == username.toLowerCase() && u.isActive,
    );
    if (matches.isEmpty) return null;

    final candidate = matches.first;
    final hash = _hashPassword(password, candidate.salt);
    if (hash != candidate.passwordHash) return null;

    final updated = candidate.copyWith(lastLogin: DateTime.now());
    await box.put(updated.id, updated);
    return updated;
  }

  @override
  Future<bool> changeUserPassword(
      String userId, String currentPassword, String newPassword) async {
    final box = await _openBox;
    final user = box.get(userId);
    if (user == null) return false;

    final currentHash = _hashPassword(currentPassword, user.salt);
    if (currentHash != user.passwordHash) return false;

    final newSalt = _generateSalt();
    final newHash = _hashPassword(newPassword, newSalt);
    final updated = user.copyWith(passwordHash: newHash, salt: newSalt);
    await box.put(userId, updated);
    return true;
  }

  @override
  Future<AdminUser> createUser({
    required String username,
    required String email,
    required String password,
    required AdminRole role,
  }) async {
    final box = await _openBox;
    final salt = _generateSalt();
    final hash = _hashPassword(password, salt);
    final newId = (box.length + 1).toString();
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
    await box.put(newId, newUser);
    return newUser;
  }

  @override
  Future<void> updateUser(AdminUser user) async {
    final box = await _openBox;
    final existing = box.get(user.id);
    if (existing != null) {
      final updated = user.copyWith(
        passwordHash: existing.passwordHash,
        salt: existing.salt,
      );
      await box.put(user.id, updated);
    }
  }

  @override
  Future<void> resetUserPassword(String userId, String newPassword) async {
    final box = await _openBox;
    final user = box.get(userId);
    if (user == null) return;

    final newSalt = _generateSalt();
    final newHash = _hashPassword(newPassword, newSalt);
    await box.put(userId, user.copyWith(passwordHash: newHash, salt: newSalt));
  }

  @override
  Future<void> deactivateUser(String userId) async {
    final box = await _openBox;
    final user = box.get(userId);
    if (user != null) {
      await box.put(userId, user.copyWith(isActive: false));
    }
  }

  @override
  Future<void> reactivateUser(String userId) async {
    final box = await _openBox;
    final user = box.get(userId);
    if (user != null) {
      await box.put(userId, user.copyWith(isActive: true));
    }
  }
}
