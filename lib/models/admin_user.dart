enum AdminRole {
  superAdmin,
  admin,
  contentManager,
  viewer;

  String get displayName {
    switch (this) {
      case AdminRole.superAdmin:
        return 'Super Admin';
      case AdminRole.admin:
        return 'Admin';
      case AdminRole.contentManager:
        return 'Content Manager';
      case AdminRole.viewer:
        return 'Viewer';
    }
  }

  bool get canManageUsers => this == superAdmin;
  bool get canManageDonations => this == superAdmin || this == admin;
  bool get canManageContent =>
      this == superAdmin || this == admin || this == contentManager;
  bool get canExportData => this == superAdmin || this == admin;
}

class AdminUser {
  final String id;
  final String username;
  final String email;
  final AdminRole role;
  final String passwordHash;
  final String salt;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    this.role = AdminRole.admin,
    this.passwordHash = '',
    this.salt = '',
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role.name,
      'passwordHash': passwordHash,
      'salt': salt,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: AdminRole.values.firstWhere(
        (r) => r.name == (json['role'] ?? 'admin'),
        orElse: () => AdminRole.admin,
      ),
      passwordHash: json['passwordHash'] ?? '',
      salt: json['salt'] ?? '',
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  AdminUser copyWith({
    String? id,
    String? username,
    String? email,
    AdminRole? role,
    String? passwordHash,
    String? salt,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return AdminUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }
}
