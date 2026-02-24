import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedWaveBackground extends StatefulWidget {
  const AnimatedWaveBackground({super.key});

  @override
  State<AnimatedWaveBackground> createState() => _AnimatedWaveBackgroundState();
}

class _AnimatedWaveBackgroundState extends State<AnimatedWaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
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
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D0A1A),
                    Color(0xFF1A1028),
                    Color(0xFF0D0A1A),
                  ],
                ),
              ),
            ),
            CustomPaint(
              painter: _WavePainter(progress: _controller.value),
            ),
          ],
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;

  _WavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    _paintWave(
      canvas: canvas,
      size: size,
      verticalOffset: size.height * 0.58,
      amplitude: 18,
      wavelength: 220,
      speed: 1.1,
      color: const Color(0xFFD4AF37).withValues(alpha: 0.20),
    );

    _paintWave(
      canvas: canvas,
      size: size,
      verticalOffset: size.height * 0.65,
      amplitude: 24,
      wavelength: 280,
      speed: 0.75,
      color: const Color(0xFFE8A317).withValues(alpha: 0.18),
    );

    _paintWave(
      canvas: canvas,
      size: size,
      verticalOffset: size.height * 0.73,
      amplitude: 30,
      wavelength: 320,
      speed: 0.45,
      color: const Color(0xFFFF6B35).withValues(alpha: 0.14),
    );
  }

  void _paintWave({
    required Canvas canvas,
    required Size size,
    required double verticalOffset,
    required double amplitude,
    required double wavelength,
    required double speed,
    required Color color,
  }) {
    final path = Path()..moveTo(0, verticalOffset);
    final phase = progress * 2 * math.pi * speed;

    for (double x = 0; x <= size.width; x++) {
      final y = verticalOffset +
          amplitude * math.sin((x / wavelength) * 2 * math.pi + phase);
      path.lineTo(x, y);
    }

    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
