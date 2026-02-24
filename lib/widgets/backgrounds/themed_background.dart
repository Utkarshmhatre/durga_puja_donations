import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/theme_service.dart';
import 'dark_firefly_background.dart';
import 'dawn_rays_background.dart';

enum AnimationQuality { high, medium, low }

class ThemedBackground extends StatelessWidget {
  final Widget child;
  final bool includeOverlay;

  const ThemedBackground({
    super.key,
    required this.child,
    this.includeOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    ThemeService? themeService;
    try {
      themeService = context.watch<ThemeService>();
    } on ProviderNotFoundException {
      themeService = null;
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reducedMotion = themeService?.reducedMotion ?? false;
    final quality = _resolveQuality(context, reducedMotion);

    final darkCount = _particleCountFor(quality);
    final rayCount = _rayCountFor(quality);

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: isDark
                ? DarkFireflyBackground(particleCount: darkCount)
                : DawnRaysBackground(rayCount: rayCount),
          ),
        ),
        if (includeOverlay)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withValues(alpha: 0.24),
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.48),
                        ]
                      : [
                          const Color(0xFFFFF3E6).withValues(alpha: 0.06),
                          const Color(0xFFFFF8F0).withValues(alpha: 0.10),
                          const Color(0xFFE8A317).withValues(alpha: 0.08),
                        ],
                ),
              ),
            ),
          ),
        Positioned.fill(child: RepaintBoundary(child: child)),
      ],
    );
  }

  AnimationQuality _resolveQuality(BuildContext context, bool reducedMotion) {
    final media = MediaQuery.of(context);
    if (reducedMotion || media.disableAnimations) {
      return AnimationQuality.low;
    }

    final shortestSide = media.size.shortestSide;
    if (shortestSide < 360) return AnimationQuality.low;
    if (shortestSide < 450) return AnimationQuality.medium;
    return AnimationQuality.high;
  }

  int _particleCountFor(AnimationQuality quality) {
    switch (quality) {
      case AnimationQuality.high:
        return 52;
      case AnimationQuality.medium:
        return 32;
      case AnimationQuality.low:
        return 18;
    }
  }

  int _rayCountFor(AnimationQuality quality) {
    switch (quality) {
      case AnimationQuality.high:
        return 18;
      case AnimationQuality.medium:
        return 12;
      case AnimationQuality.low:
        return 8;
    }
  }
}
