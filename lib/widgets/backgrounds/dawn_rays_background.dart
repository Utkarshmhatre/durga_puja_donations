import 'dart:math' as math;
import 'package:flutter/material.dart';

class DawnRaysBackground extends StatefulWidget {
  final int rayCount;

  const DawnRaysBackground({
    super.key,
    required this.rayCount,
  });

  @override
  State<DawnRaysBackground> createState() => _DawnRaysBackgroundState();
}

class _DawnRaysBackgroundState extends State<DawnRaysBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
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
          painter: SunRaysPainter(
            progress: _controller.value,
            rayCount: widget.rayCount,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class SunRaysPainter extends CustomPainter {
  final double progress;
  final int rayCount;

  SunRaysPainter({
    required this.progress,
    required this.rayCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const base = LinearGradient(
      begin: Alignment(-1.0, -0.15),
      end: Alignment(0.75, 1.0),
      colors: [
        Color(0xFFFFF3E6),
        Color(0xFFFFF8F0),
        Color(0xFFFDDCDC),
      ],
      stops: [0.0, 0.52, 1.0],
    );

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = base.createShader(Offset.zero & size),
    );

    final origin = Offset(size.width * 0.82, size.height * 0.08);
    final pulse = 0.84 + 0.16 * math.sin(progress * 2 * math.pi);
    final maxRadius = size.longestSide * (0.95 + 0.12 * pulse);

    for (int i = 0; i < rayCount; i++) {
      final angle = (-math.pi * 0.85) + (i / rayCount) * (math.pi * 0.95);
      final spread = (math.pi / rayCount) * 0.7;
      final dynamicOpacity =
          0.16 + 0.12 * (0.5 + 0.5 * math.sin(progress * 4 * math.pi + i));

      final p1 = origin;
      final p2 = Offset(
        origin.dx + maxRadius * math.cos(angle - spread),
        origin.dy + maxRadius * math.sin(angle - spread),
      );
      final p3 = Offset(
        origin.dx + maxRadius * math.cos(angle + spread),
        origin.dy + maxRadius * math.sin(angle + spread),
      );

      final rayPath = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..close();

      canvas.drawPath(
        rayPath,
        Paint()
          ..shader = RadialGradient(
            center: Alignment.topRight,
            radius: 1.4,
            colors: [
              const Color(0xFFFFFDF7).withValues(alpha: dynamicOpacity + 0.14),
              const Color(0xFFE8A317).withValues(alpha: dynamicOpacity * 0.75),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: origin, radius: maxRadius)),
      );
    }

    // Sun core glow to make rays visible even on bright devices.
    canvas.drawCircle(
      origin,
      64 + (16 * pulse),
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFFDF7).withValues(alpha: 0.9),
            const Color(0xFFE8A317).withValues(alpha: 0.28),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: origin, radius: 90)),
    );

    final hazeShift = math.sin(progress * 2 * math.pi) * size.width * 0.05;
    final hazeRect = Rect.fromLTWH(-size.width * 0.2 + hazeShift,
        size.height * 0.22, size.width * 1.4, size.height * 0.8);
    canvas.drawOval(
      hazeRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFFDF7).withValues(alpha: 0.22),
            const Color(0xFFFFF3E6).withValues(alpha: 0.16),
            Colors.transparent,
          ],
        ).createShader(hazeRect),
    );
  }

  @override
  bool shouldRepaint(covariant SunRaysPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.rayCount != rayCount;
  }
}
