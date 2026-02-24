import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_scaffold.dart';
import 'src/localization/app_localizations.dart';
import 'utils/theme.dart';

class BallBounceIndex extends StatefulWidget {
  const BallBounceIndex({super.key});

  @override
  State<BallBounceIndex> createState() => _BallBounceIndexState();
}

class _BallBounceIndexState extends State<BallBounceIndex>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _ringController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _logoOpacity;
  late Animation<double> _backgroundExpand;
  late Animation<double> _pulseAnimation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Background expand
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundExpand = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Pulse animation for glow
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Particle controller
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Ring animation
    _ringController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _ringScale = Tween<double>(begin: 0.5, end: 2.5).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );

    _ringOpacity = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _backgroundController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    _pulseController.repeat(reverse: true);
    _ringController.repeat();

    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Navigate after splash
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScaffold(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark animated background
          _buildAnimatedBackground(),

          // Floating particles
          _buildParticles(),

          // Expanding rings
          _buildExpandingRings(),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                _buildAnimatedLogo(),

                const SizedBox(height: 40),

                // Animated Text
                _buildAnimatedText(),
              ],
            ),
          ),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Loading indicator at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: _buildLoadingIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5 * _backgroundExpand.value + 0.5,
              colors: [
                Color.lerp(
                      const Color(0xFF1A1028),
                      const Color(0xFF2D1040),
                      _backgroundExpand.value,
                    ) ??
                    const Color(0xFF2D1040),
                Color.lerp(
                      const Color(0xFF0D0A1A),
                      const Color(0xFF1A1028),
                      _backgroundExpand.value,
                    ) ??
                    const Color(0xFF1A1028),
                const Color(0xFF0D0A1A),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            animation: _particleController.value,
            particleCount: 30,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildExpandingRings() {
    return AnimatedBuilder(
      animation: _ringController,
      builder: (context, child) {
        return Center(
          child: Opacity(
            opacity: _ringOpacity.value,
            child: Container(
              width: 200 * _ringScale.value,
              height: 200 * _ringScale.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.sacredGold.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _pulseController]),
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacity.value,
          child: Transform.scale(
            scale: _logoScale.value * _pulseAnimation.value,
            child: Transform.rotate(
              angle: _logoRotation.value * math.pi,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.vermillion,
                      AppTheme.sacredGold,
                      AppTheme.darkBackground,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.vermillion.withValues(alpha: 0.5),
                      blurRadius: 40 * _pulseAnimation.value,
                      spreadRadius: 10 * _pulseAnimation.value,
                    ),
                    BoxShadow(
                      color: AppTheme.sacredGold.withValues(alpha: 0.3),
                      blurRadius: 60 * _pulseAnimation.value,
                      spreadRadius: 20 * _pulseAnimation.value,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.temple_hindu,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacity.value,
          child: SlideTransition(
            position: _textSlide,
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      AppTheme.vermillion,
                      AppTheme.goldBright,
                      AppTheme.vermillion,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ).createShader(bounds),
                  child: Text(
                    AppLocalizations.of(context)!.splashTitle,
                    style: const TextStyle(
                      fontFamily: 'HindSiliguri',
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.splashYear,
                  style: const TextStyle(
                    fontFamily: 'HindSiliguri',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppTheme.sacredGold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'শুভ দুর্গা পূজা',
                    style: TextStyle(
                      fontFamily: 'HindSiliguri',
                      fontSize: 16,
                      color: AppTheme.goldBright,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 120,
          child: AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _backgroundController.value,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.sacredGold,
                  ),
                  minHeight: 3,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.splashLoading,
          style: const TextStyle(
            fontFamily: 'HindSiliguri',
            color: Colors.white38,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animation;
  final int particleCount;

  ParticlePainter({
    required this.animation,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < particleCount; i++) {
      final progress = (animation + i / particleCount) % 1.0;
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final y = (baseY - progress * size.height * 0.5) % size.height;

      final opacity = (1 - progress) * 0.5;
      final particleSize = random.nextDouble() * 3 + 1;

      final blended = Color.lerp(
            AppTheme.vermillion,
            AppTheme.sacredGold,
            random.nextDouble(),
          ) ??
          AppTheme.deepSaffron;
      paint.color = blended.withValues(alpha: opacity);

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
