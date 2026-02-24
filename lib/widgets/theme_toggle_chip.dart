import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../utils/theme.dart';

class ThemeToggleChip extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  const ThemeToggleChip({super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    ThemeService? themeService;
    try {
      themeService = context.watch<ThemeService>();
    } on ProviderNotFoundException {
      themeService = null;
    }
    final isDark =
        (themeService?.themeMode ?? ThemeMode.dark) == ThemeMode.dark;
    final fgColor = isDark ? Colors.white : const Color(0xFF4A3520);
    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.60);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.25)
              : AppTheme.sacredGold.withValues(alpha: 0.45),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => themeService?.toggleTheme(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                size: 16,
                color: fgColor,
              ),
              const SizedBox(width: 6),
              Text(
                isDark ? 'Mahakali Night' : 'Subho Dawn',
                style: TextStyle(
                  color: fgColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
