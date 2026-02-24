import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class DarkFireflyBackground extends StatefulWidget {
  final int particleCount;

  const DarkFireflyBackground({
    super.key,
    required this.particleCount,
  });

  @override
  State<DarkFireflyBackground> createState() => _DarkFireflyBackgroundState();
}

class _DarkFireflyBackgroundState extends State<DarkFireflyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FireflyPainter(
            progress: _controller.value,
            particleCount: widget.particleCount,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class FireflyPainter extends CustomPainter {
  final double progress;
  final int particleCount;

  FireflyPainter({
    required this.progress,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.darkBackground,
          AppTheme.darkSurface,
          AppTheme.darkBackground,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    for (int i = 0; i < particleCount; i++) {
      final lane = i % 3;
      final laneSpeed = lane == 0
          ? 0.35
          : lane == 1
              ? 0.55
              : 0.85;
      final laneAmplitude = lane == 0
          ? 12.0
          : lane == 1
              ? 18.0
              : 22.0;
      final seed = i * 13.73;

      final baseX = (math.sin(seed) * 0.5 + 0.5) * size.width;
      final verticalCycle = (progress * laneSpeed + (i / particleCount)) % 1.0;
      final y = size.height - (verticalCycle * size.height * 1.2);
      final x =
          baseX + math.sin((progress * 2 * math.pi) + seed) * laneAmplitude;

      final twinkle =
          0.25 + 0.75 * (0.5 + 0.5 * math.sin(progress * 12 * math.pi + seed));
      final radius = (lane + 1) * 1.1 + twinkle * 1.2;
      final blended = Color.lerp(
            AppTheme.sacredGold,
            AppTheme.goldBright,
            lane / 2,
          ) ??
          AppTheme.turmericGold;
      final color = blended.withValues(alpha: 0.18 + 0.56 * twinkle);

      // Soft trail for premium "jugnu glow" effect.
      final trailPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.32),
            color.withValues(alpha: 0.0),
          ],
        ).createShader(
            Rect.fromCircle(center: Offset(x, y), radius: radius * 4.2));
      canvas.drawCircle(Offset(x, y), radius * 4.2, trailPaint);

      canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant FireflyPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.particleCount != particleCount;
  }
}
