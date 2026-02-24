import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../services/auth_service.dart';
import '../services/app_settings_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';
import 'admin_dashboard.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _secureTried = false;

  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final bool _autoAuthAttempted = false;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleSecureAttemptIfNeeded();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _backgroundController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    HapticFeedback.mediumImpact();
    await _performLogin(
      _usernameController.text.trim(),
      _passwordController.text,
    );
  }

  Future<void> _performLogin(String username, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = context.read<AuthService>();
    final result = await authService.login(username, password);

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AdminDashboard(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOutCubic)),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } else {
      HapticFeedback.vibrate();
      setState(() {
        _errorMessage = result.message;
      });
    }
  }

  Future<void> _loginWithBiometric() async {
    if (_isLoading) return;
    HapticFeedback.selectionClick();
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();
      final canAuth = canCheck || supported;
      if (!canAuth) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.adminBiometricUnavailable)),
        );
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: AppLocalizations.of(context)!.adminBiometricReason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (!didAuthenticate || !mounted) return;
      await _performLogin('admin', 'admin123');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!
                .adminBiometricFailed(e.toString()))),
      );
    }
  }

  Future<void> _loginWithPin() async {
    if (_isLoading) return;
    final settings = context.read<AppSettingsService>();
    final pin = await _askForPin();
    if (pin == null || !mounted) return;

    if (!settings.verifyPin(pin)) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.adminInvalidPin;
      });
      return;
    }

    await _performLogin('admin', 'admin123');
  }

  Future<String?> _askForPin() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.adminEnterPin),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.adminPinHint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final pin = controller.text.trim();
                if (pin.length == 4 && RegExp(r'^\d{4}$').hasMatch(pin)) {
                  Navigator.pop(dialogContext, pin);
                }
              },
              child: Text(AppLocalizations.of(context)!.verify),
            ),
          ],
        );
      },
    );
  }

  Future<void> _maybeTriggerSecureLogin() async {
    if (!mounted) return;
    final settings = context.read<AppSettingsService>();
    final useBiometric = settings.biometricEnabled;
    final usePin = settings.pinEnabled && settings.hasPin;
    if (!useBiometric && !usePin) return;

    if (useBiometric) {
      await _loginWithBiometric();
      if (!mounted) return;
      if (context.read<AuthService>().isAuthenticated) return;
    }

    if (usePin && mounted && !context.read<AuthService>().isAuthenticated) {
      await _loginWithPin();
    }
  }

  void _scheduleSecureAttemptIfNeeded() {
    if (_secureTried) return;
    final settings = context.read<AppSettingsService>();
    if (!(settings.biometricEnabled ||
        (settings.pinEnabled && settings.hasPin))) {
      return;
    }
    _secureTried = true;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _maybeTriggerSecureLogin());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isLandscape = size.width > size.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            // Animated Background
            _buildAnimatedBackground(),

            // Decorative Elements
            _buildDecorativeElements(size),

            // Main Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : 24,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isLandscape ? 500 : 400,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo and Title
                        _buildHeader(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 24 : 40),

                        // Login Form Card
                        _buildLoginCard(isSmallScreen),

                        const SizedBox(height: 24),

                        // Back Button
                        _buildBackButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        final bgColors = AppTheme.dynamicGradientBg(context);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                bgColors[0],
                Color.lerp(
                      bgColors[1],
                      bgColors[2],
                      _backgroundController.value,
                    ) ??
                    bgColors[2],
                bgColors[0],
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDecorativeElements(Size size) {
    return Stack(
      children: [
        // Top Right Circle
        Positioned(
          top: -80,
          right: -80,
          child: FadeInDown(
            duration: const Duration(milliseconds: 1500),
            child: AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (_backgroundController.value * 0.1),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.sacredGold.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Bottom Left Circle
        Positioned(
          bottom: -120,
          left: -80,
          child: FadeInUp(
            duration: const Duration(milliseconds: 1500),
            child: AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + ((1 - _backgroundController.value) * 0.1),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primaryOrange.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isSmall) {
    return Column(
      children: [
        // Animated Logo
        FadeInDown(
          duration: const Duration(milliseconds: 800),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: EdgeInsets.all(isSmall ? 16 : 22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.sacredGold.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: isSmall ? 44 : 56,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: isSmall ? 16 : 24),

        // Title
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 800),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                AppTheme.primaryOrange,
                AppTheme.primaryGold,
                AppTheme.primaryPurple
              ],
            ).createShader(bounds),
            child: Text(
              AppLocalizations.of(context)!.adminPortalTitle,
              style: TextStyle(
                fontSize: isSmall ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle
        FadeInDown(
          delay: const Duration(milliseconds: 300),
          duration: const Duration(milliseconds: 800),
          child: Text(
            AppLocalizations.of(context)!.adminPortalSubtitle,
            style: TextStyle(
              fontSize: isSmall ? 12 : 14,
              color: AppTheme.dynamicTextMuted(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(bool isSmall) {
    final settings = context.watch<AppSettingsService>();
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 800),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(isSmall ? 20 : 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.dynamicOverlay(context, alpha: 0.15),
                  AppTheme.dynamicOverlay(context, alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.dynamicDivider(context),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Username Field
                  _buildTextField(
                    controller: _usernameController,
                    label: AppLocalizations.of(context)!.adminUsernameLabel,
                    icon: Icons.person_outline_rounded,
                    isSmall: isSmall,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .adminUsernameValidation;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: isSmall ? 14 : 18),

                  // Password Field
                  _buildTextField(
                    controller: _passwordController,
                    label: AppLocalizations.of(context)!.adminPasswordLabel,
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    isSmall: isSmall,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .adminPasswordValidation;
                      }
                      return null;
                    },
                  ),

                  // Error Message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    FadeIn(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.accentRed.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppTheme.accentRed,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: AppTheme.accentRed,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: isSmall ? 20 : 28),

                  // Login Button
                  _buildLoginButton(isSmall),

                  if (settings.biometricEnabled ||
                      (settings.pinEnabled && settings.hasPin)) ...[
                    const SizedBox(height: 12),
                    _buildQuickLoginRow(
                      isSmall: isSmall,
                      showBiometric: settings.biometricEnabled,
                      showPin: settings.pinEnabled && settings.hasPin,
                    ),
                  ],

                  SizedBox(height: isSmall ? 16 : 20),

                  // Demo Credentials
                  _buildDemoCredentials(isSmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isSmall,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: TextStyle(
        color: AppTheme.dynamicTextPrimary(context),
        fontSize: isSmall ? 14 : 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppTheme.dynamicTextMuted(context),
          fontSize: isSmall ? 13 : 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppTheme.dynamicTextMuted(context),
          size: isSmall ? 20 : 22,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppTheme.dynamicTextMuted(context),
                  size: isSmall ? 20 : 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isSmall ? 14 : 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppTheme.dynamicDivider(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppTheme.primaryPurple,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppTheme.accentRed,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppTheme.accentRed,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          color: AppTheme.accentRed,
          fontSize: 11,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildLoginButton(bool isSmall) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleLogin,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isSmall ? 50 : 56,
        decoration: BoxDecoration(
          gradient: _isLoading
              ? LinearGradient(
                  colors: [
                    AppTheme.sacredGold.withValues(alpha: 0.5),
                    AppTheme.primaryOrange.withValues(alpha: 0.5),
                  ],
                )
              : AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.sacredGold.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login_rounded,
                      color: Colors.white,
                      size: isSmall ? 20 : 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.adminSignIn,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmall ? 15 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDemoCredentials(bool isSmall) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 10 : 14),
      decoration: BoxDecoration(
        color: AppTheme.accentCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentCyan.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppTheme.accentCyan,
                size: isSmall ? 14 : 16,
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.adminDemoCredentials,
                style: TextStyle(
                  color: AppTheme.accentCyan,
                  fontWeight: FontWeight.w600,
                  fontSize: isSmall ? 11 : 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              AppLocalizations.of(context)!.adminDemoCredentialsDetail,
              style: TextStyle(
                color: AppTheme.dynamicTextSecondary(context),
                fontSize: isSmall ? 10 : 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLoginRow({
    required bool isSmall,
    required bool showBiometric,
    required bool showPin,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        if (showBiometric)
          _buildQuickActionButton(
            label: AppLocalizations.of(context)!.adminBiometricLabel,
            icon: Icons.fingerprint_rounded,
            isSmall: isSmall,
            onTap: _loginWithBiometric,
          ),
        if (showPin)
          _buildQuickActionButton(
            label: AppLocalizations.of(context)!.adminPinLogin,
            icon: Icons.pin_rounded,
            isSmall: isSmall,
            onTap: _loginWithPin,
          ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required bool isSmall,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : onTap,
      icon: Icon(icon,
          size: isSmall ? 16 : 18,
          color: AppTheme.dynamicTextSecondary(context)),
      label: Text(
        label,
        style: TextStyle(
          color: AppTheme.dynamicTextSecondary(context),
          fontSize: isSmall ? 11 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppTheme.dynamicDivider(context)),
        backgroundColor: AppTheme.dynamicOverlay(context, alpha: 0.04),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildBackButton() {
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      duration: const Duration(milliseconds: 800),
      child: TextButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_rounded,
          color: AppTheme.dynamicTextMuted(context),
          size: 18,
        ),
        label: Text(
          AppLocalizations.of(context)!.adminBackToHome,
          style: TextStyle(
            color: AppTheme.dynamicTextMuted(context),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
