import 'package:flutter/material.dart';
import '../models/admin_user.dart';
import '../repositories/admin_auth_repository.dart';

class AuthService extends ChangeNotifier {
  final AdminAuthRepository _authRepository;

  AdminUser? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  AdminUser? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  AuthService({AdminAuthRepository? authRepository})
      : _authRepository = authRepository ?? SharedPrefsAdminAuthRepository() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    // Ensure default super-admin exists on first run
    await _authRepository.ensureDefaultAdmin();
    await _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    final user = await _authRepository.loadUser();

    if (isLoggedIn && user != null) {
      _currentUser = user;
      _isAuthenticated = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<AuthResult> login(String username, String password) async {
    await Future.delayed(
        const Duration(milliseconds: 300)); // Brief delay for UX

    final user = await _authRepository.authenticateUser(username, password);
    if (user == null) {
      return AuthResult(
          success: false, message: 'Invalid username or password');
    }

    _currentUser = user;
    _isAuthenticated = true;
    await _authRepository.saveUserSession(user);

    notifyListeners();
    return AuthResult(success: true, message: 'Login successful');
  }

  Future<void> logout() async {
    await _authRepository.clearSession();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<AuthResult> changePassword(
      String currentPassword, String newPassword) async {
    if (_currentUser == null) {
      return AuthResult(success: false, message: 'Not authenticated');
    }

    final success = await _authRepository.changeUserPassword(
      _currentUser!.id,
      currentPassword,
      newPassword,
    );

    if (!success) {
      return AuthResult(
          success: false, message: 'Current password is incorrect');
    }

    return AuthResult(success: true, message: 'Password changed successfully');
  }

  // ── User management (delegates to repository) ──────────────────

  AdminAuthRepository get repository => _authRepository;

  Future<List<AdminUser>> getAllUsers() => _authRepository.loadAllUsers();

  Future<AdminUser> createUser({
    required String username,
    required String email,
    required String password,
    required AdminRole role,
  }) =>
      _authRepository.createUser(
        username: username,
        email: email,
        password: password,
        role: role,
      );

  Future<void> updateUser(AdminUser user) => _authRepository.updateUser(user);

  Future<void> deactivateUser(String userId) =>
      _authRepository.deactivateUser(userId);

  Future<void> reactivateUser(String userId) =>
      _authRepository.reactivateUser(userId);

  Future<void> resetUserPassword(String userId, String newPassword) =>
      _authRepository.resetUserPassword(userId, newPassword);

  /// Check if current user has permission for an action
  bool hasPermission(bool Function(AdminRole) check) {
    if (_currentUser == null) return false;
    return check(_currentUser!.role);
  }
}

class AuthResult {
  final bool success;
  final String message;

  AuthResult({required this.success, required this.message});
}
