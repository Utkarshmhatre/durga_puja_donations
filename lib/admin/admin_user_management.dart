import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../models/admin_user.dart';
import '../services/auth_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';

class AdminUserManagementPage extends StatefulWidget {
  const AdminUserManagementPage({super.key});

  @override
  State<AdminUserManagementPage> createState() =>
      _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  List<AdminUser> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final authService = context.read<AuthService>();
    final users = await authService.getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final currentUser = context.read<AuthService>().currentUser;
    final canManage = currentUser?.role.canManageUsers ?? false;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(isSmall ? 16 : 24),
            child: FadeInDown(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.userManagementTitle,
                          style: TextStyle(
                            fontSize: isSmall ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.dynamicTextPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!
                              .userManagementSubtitle(_users.length),
                          style: TextStyle(
                            fontSize: isSmall ? 12 : 14,
                            color: AppTheme.dynamicTextMuted(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (canManage)
                    GestureDetector(
                      onTap: () => _showAddUserDialog(context),
                      child: Container(
                        padding: EdgeInsets.all(isSmall ? 10 : 12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.sacredGoldGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.sacredGold.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          color: Colors.white,
                          size: isSmall ? 20 : 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // User List
          Expanded(
            child: _isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppTheme.sacredGold))
                : _users.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline,
                                size: 80,
                                color: AppTheme.dynamicTextHint(context)),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!
                                  .userManagementNoUsers,
                              style: TextStyle(
                                  color: AppTheme.dynamicTextMuted(context),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          return FadeInUp(
                            delay: Duration(milliseconds: index * 80),
                            child: _buildUserCard(
                                _users[index], canManage, isSmall),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(AdminUser user, bool canManage, bool isSmall) {
    final roleColor = _getRoleColor(user.role);
    final isSelf = context.read<AuthService>().currentUser?.id == user.id;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.dynamicOverlay(context, alpha: 0.1),
                AppTheme.dynamicOverlay(context, alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: user.isActive
                  ? AppTheme.dynamicDivider(context)
                  : AppTheme.accentRed.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: isSmall ? 44 : 52,
                height: isSmall ? 44 : 52,
                decoration: BoxDecoration(
                  gradient: user.isActive
                      ? LinearGradient(
                          colors: [roleColor.withValues(alpha: 0.7), roleColor])
                      : null,
                  color: user.isActive ? null : Colors.grey,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    user.username[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmall ? 18 : 22,
                    ),
                  ),
                ),
              ),
              SizedBox(width: isSmall ? 10 : 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.username,
                          style: TextStyle(
                            color: user.isActive
                                ? AppTheme.dynamicTextPrimary(context)
                                : AppTheme.dynamicTextMuted(context),
                            fontWeight: FontWeight.w600,
                            fontSize: isSmall ? 13 : 15,
                          ),
                        ),
                        if (isSelf) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentCyan.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.userManagementYou,
                              style: const TextStyle(
                                color: AppTheme.accentCyan,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        if (!user.isActive) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentRed.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .userManagementInactive,
                              style: const TextStyle(
                                color: AppTheme.accentRed,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: AppTheme.dynamicTextMuted(context),
                        fontSize: isSmall ? 11 : 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Role badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            user.role.displayName,
                            style: TextStyle(
                              color: roleColor,
                              fontSize: isSmall ? 9 : 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (user.lastLogin != null)
                          Text(
                            '${AppLocalizations.of(context)!.userManagementLastLogin}: ${_formatDate(user.lastLogin!)}',
                            style: TextStyle(
                              color: AppTheme.dynamicTextHint(context),
                              fontSize: isSmall ? 9 : 10,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              if (canManage && !isSelf)
                PopupMenuButton<String>(
                  onSelected: (value) => _handleUserAction(value, user),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_rounded,
                              color: AppTheme.accentCyan, size: 18),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'reset_password',
                      child: Row(
                        children: [
                          const Icon(Icons.lock_reset_rounded,
                              color: AppTheme.sacredGold, size: 18),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!
                              .userManagementResetPassword),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: user.isActive ? 'deactivate' : 'reactivate',
                      child: Row(
                        children: [
                          Icon(
                            user.isActive
                                ? Icons.person_off_rounded
                                : Icons.person_rounded,
                            color: user.isActive
                                ? AppTheme.accentRed
                                : AppTheme.accentGreen,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(user.isActive
                              ? AppLocalizations.of(context)!
                                  .userManagementDeactivate
                              : AppLocalizations.of(context)!
                                  .userManagementReactivate),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppTheme.dynamicTextMuted(context),
                    size: isSmall ? 18 : 22,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(AdminRole role) {
    switch (role) {
      case AdminRole.superAdmin:
        return AppTheme.sacredGold;
      case AdminRole.admin:
        return AppTheme.vermillion;
      case AdminRole.contentManager:
        return AppTheme.accentCyan;
      case AdminRole.viewer:
        return AppTheme.accentGreen;
    }
  }

  void _handleUserAction(String action, AdminUser user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(context, user);
        break;
      case 'reset_password':
        _showResetPasswordDialog(context, user);
        break;
      case 'deactivate':
        _showDeactivateDialog(context, user);
        break;
      case 'reactivate':
        _reactivateUser(user);
        break;
    }
  }

  Future<void> _reactivateUser(AdminUser user) async {
    final authService = context.read<AuthService>();
    await authService.reactivateUser(user.id);
    await _loadUsers();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!
                .userManagementReactivated(user.username))),
      );
    }
  }

  void _showAddUserDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    AdminRole selectedRole = AdminRole.viewer;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.dynamicCardBg(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.sacredGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_add_rounded,
                    color: AppTheme.sacredGold, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.userManagementAddUser,
                style: TextStyle(
                    color: AppTheme.dynamicTextPrimary(context),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogTextField(
                    controller: usernameController,
                    label: AppLocalizations.of(context)!.adminUsernameLabel,
                    icon: Icons.person_outline,
                    validator: (v) => (v == null || v.isEmpty)
                        ? AppLocalizations.of(context)!.adminUsernameValidation
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _dialogTextField(
                    controller: emailController,
                    label: AppLocalizations.of(context)!.userManagementEmail,
                    icon: Icons.email_outlined,
                    validator: (v) => (v == null || !v.contains('@'))
                        ? AppLocalizations.of(context)!
                            .userManagementEmailValidation
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _dialogTextField(
                    controller: passwordController,
                    label: AppLocalizations.of(context)!.adminPasswordLabel,
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (v) => (v == null || v.length < 6)
                        ? AppLocalizations.of(context)!
                            .userManagementPasswordValidation
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Role selector
                  DropdownButtonFormField<AdminRole>(
                    initialValue: selectedRole,
                    dropdownColor: AppTheme.dynamicCardBg(context),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.userManagementRole,
                      labelStyle:
                          TextStyle(color: AppTheme.dynamicTextMuted(context)),
                      filled: true,
                      fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style:
                        TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                    items: AdminRole.values
                        .map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.displayName),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => selectedRole = v);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: AppTheme.dynamicTextMuted(context))),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final authService = context.read<AuthService>();
                  await authService.createUser(
                    username: usernameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text,
                    role: selectedRole,
                  );
                  Navigator.pop(dialogContext);
                  await _loadUsers();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .userManagementCreated(
                                  usernameController.text.trim()))),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sacredGold,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                AppLocalizations.of(context)!.userManagementCreate,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, AdminUser user) {
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    AdminRole selectedRole = user.role;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.dynamicCardBg(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: AppTheme.accentCyan, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.userManagementEditUser,
                style: TextStyle(
                    color: AppTheme.dynamicTextPrimary(context),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogTextField(
                    controller: usernameController,
                    label: AppLocalizations.of(context)!.adminUsernameLabel,
                    icon: Icons.person_outline,
                    validator: (v) => (v == null || v.isEmpty)
                        ? AppLocalizations.of(context)!.adminUsernameValidation
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _dialogTextField(
                    controller: emailController,
                    label: AppLocalizations.of(context)!.userManagementEmail,
                    icon: Icons.email_outlined,
                    validator: (v) => (v == null || !v.contains('@'))
                        ? AppLocalizations.of(context)!
                            .userManagementEmailValidation
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AdminRole>(
                    initialValue: selectedRole,
                    dropdownColor: AppTheme.dynamicCardBg(context),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.userManagementRole,
                      labelStyle:
                          TextStyle(color: AppTheme.dynamicTextMuted(context)),
                      filled: true,
                      fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style:
                        TextStyle(color: AppTheme.dynamicTextPrimary(context)),
                    items: AdminRole.values
                        .map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.displayName),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => selectedRole = v);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: AppTheme.dynamicTextMuted(context))),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final authService = context.read<AuthService>();
                  final updated = user.copyWith(
                    username: usernameController.text.trim(),
                    email: emailController.text.trim(),
                    role: selectedRole,
                  );
                  await authService.updateUser(updated);
                  Navigator.pop(dialogContext);
                  await _loadUsers();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .userManagementUpdated(
                                  usernameController.text.trim()))),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentCyan,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context, AdminUser user) {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.sacredGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.lock_reset_rounded,
                  color: AppTheme.sacredGold, size: 20),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!
                    .userManagementResetPasswordFor(user.username),
                style: TextStyle(
                    color: AppTheme.dynamicTextPrimary(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: _dialogTextField(
            controller: passwordController,
            label: AppLocalizations.of(context)!.userManagementNewPassword,
            icon: Icons.lock_outline,
            obscure: true,
            validator: (v) => (v == null || v.length < 6)
                ? AppLocalizations.of(context)!.userManagementPasswordValidation
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: AppTheme.dynamicTextMuted(context))),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final authService = context.read<AuthService>();
                await authService.resetUserPassword(
                    user.id, passwordController.text);
                Navigator.pop(dialogContext);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .userManagementPasswordReset(user.username))),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sacredGold,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              AppLocalizations.of(context)!.userManagementResetPassword,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context, AdminUser user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_off_rounded,
                  color: AppTheme.accentRed, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.userManagementDeactivateTitle,
              style: TextStyle(
                  color: AppTheme.dynamicTextPrimary(context),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!
              .userManagementDeactivateConfirm(user.username),
          style: TextStyle(color: AppTheme.dynamicTextSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: AppTheme.dynamicTextMuted(context))),
          ),
          ElevatedButton(
            onPressed: () async {
              final authService = context.read<AuthService>();
              await authService.deactivateUser(user.id);
              Navigator.pop(dialogContext);
              await _loadUsers();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .userManagementDeactivated(user.username))),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              AppLocalizations.of(context)!.userManagementDeactivate,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style:
          TextStyle(color: AppTheme.dynamicTextPrimary(context), fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: AppTheme.dynamicTextMuted(context), fontSize: 13),
        prefixIcon:
            Icon(icon, color: AppTheme.dynamicTextMuted(context), size: 20),
        filled: true,
        fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
