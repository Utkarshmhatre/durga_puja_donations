import 'package:flutter/material.dart';

class AppTheme {
  // ── Cultural palette ─────────────────────────────────────────────
  // Sacred vermillion (sindoor / alta)
  static const Color vermillion = Color(0xFFE23D28);
  static const Color vermillionDark = Color(0xFFC41E3A);
  static const Color vermillionDeep = Color(0xFF8B1A1A);

  // Sacred gold (sindoor dana / ornaments)
  static const Color sacredGold = Color(0xFFD4AF37);
  static const Color goldBright = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFB8860B);

  // Deep saffron (dhunuchi fire / marigold)
  static const Color deepSaffron = Color(0xFFFF6B35);

  // Mango-leaf green (aam pata torana)
  static const Color mangoLeafGreen = Color(0xFF2E7D32);

  // Turmeric gold (haldi / gada / mace)
  static const Color turmericGold = Color(0xFFE8A317);

  // Legacy aliases kept for backward compatibility
  static const Color primaryPurple = Color(0xFF6B21A8);
  static const Color primaryOrange = deepSaffron;
  static const Color primaryGold = sacredGold;

  // ── Dark theme: "Mahakali Night" ─────────────────────────────────
  static const Color darkBackground = Color(0xFF0D0A1A);
  static const Color darkSurface = Color(0xFF1A1028);
  static const Color cardBackground = Color(0xFF231538);
  static const Color surfaceColor = darkSurface;
  static const Color cardColor = cardBackground;

  static const Color gradientStart = Color(0xFF0D0A1A);
  static const Color gradientMiddle = Color(0xFF2D1040);
  static const Color gradientEnd = Color(0xFF4A1A6B);

  static const Color darkBase = darkBackground;
  static const Color darkDeepBlue = darkSurface;
  static const Color darkElectricBlue = sacredGold;
  static const Color darkElectricBlueSoft = turmericGold;

  // ── Light theme: "Subho Dawn" ────────────────────────────────────
  static const Color dawnBackground = Color(0xFFFFF8F0);
  static const Color dawnSurface = Color(0xFFFFF3E6);
  static const Color dawnCardBg = Color(0xFFFFFAF5);
  static const Color dawnPista = Color(0xFFFFF3E6);
  static const Color dawnWhite = dawnBackground;
  static const Color dawnRedWarm = vermillion;
  static const Color dawnLeaf = vermillionDark;

  // ── Accents ──────────────────────────────────────────────────────
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentRed = Color(0xFFEF4444);

  // ── Text colors ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD3D8E6);
  static const Color textMuted = Color(0xFF9BA6C2);

  // ── Standardised border radii ────────────────────────────────────
  static const double radiusCard = 20;
  static const double radiusButton = 16;
  static const double radiusChip = 12;

  // ── Cultural gradients ───────────────────────────────────────────
  static const LinearGradient vermillionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [vermillion, vermillionDark, vermillionDeep],
  );

  static const LinearGradient sacredGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldBright, sacredGold, goldDark],
  );

  static const LinearGradient festivalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [vermillion, sacredGold, deepSaffron],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBackground, gradientStart, Color(0xFF0D0D14)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D1B4E), Color(0xFF1A1A2E)],
  );

  static const LinearGradient goldGradient = sacredGoldGradient;

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepSaffron, Color(0xFFEA580C), Color(0xFFC2410C)],
  );

  /// Subtle alpona pattern color for background decoration
  static Color alponaPatternColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.06)
        : vermillionDark.withValues(alpha: 0.04);
  }

  static Color dynamicTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF1A1A2E);
  }

  static Color dynamicTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFD3D8E6)
        : const Color(0xFF4A4A5A);
  }

  static Color dynamicTextMuted(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9BA6C2)
        : const Color(0xFF7A7A8A);
  }

  static Color dynamicTextHint(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF6B7999)
        : const Color(0xFF9A9AAA);
  }

  static Color dynamicCardBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardBackground
        : Colors.white;
  }

  static Color dynamicSurfaceBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : dawnSurface;
  }

  static Color dynamicScaffoldBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : dawnBackground;
  }

  static Color dynamicDivider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.08);
  }

  static Color dynamicIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF4A4A5A);
  }

  static Color dynamicOverlay(BuildContext context, {double alpha = 0.08}) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: alpha)
        : Colors.black.withValues(alpha: alpha * 0.5);
  }

  static List<Color> dynamicGradientBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const [Color(0xFF0F0F1A), Color(0xFF1E1B4B), Color(0xFF312E81)]
        : const [Color(0xFFFFF8F0), Color(0xFFFFF3E6), Color(0xFFFFEDD5)];
  }

  static BoxDecoration glassDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark
          ? Colors.white.withValues(alpha: 0.10)
          : Colors.white.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(radiusCard),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.18)
            : sacredGold.withValues(alpha: 0.25),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.25)
              : vermillion.withValues(alpha: 0.12),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const textOnDark = Color(0xFFF4F7FF);
    const secondaryOnDark = Color(0xFFD3D8E6);
    const mutedOnDark = Color(0xFFA5B2CC);

    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: darkBase,
      fontFamily: 'HindSiliguri',
      fontFamilyFallback: const ['Roboto'],
      colorScheme: const ColorScheme.dark(
        primary: sacredGold,
        secondary: vermillion,
        surface: darkSurface,
        error: accentRed,
      ),
    );

    return base.copyWith(
      primaryColor: sacredGold,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textOnDark),
        titleTextStyle: TextStyle(
          fontFamily: 'HindSiliguri',
          color: textOnDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'HindSiliguri',
            color: textOnDark,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5),
        displayMedium: TextStyle(
            fontFamily: 'HindSiliguri',
            color: textOnDark,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5),
        displaySmall: TextStyle(
            fontFamily: 'HindSiliguri',
            color: textOnDark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5),
        headlineMedium: TextStyle(
            fontFamily: 'HindSiliguri',
            color: textOnDark,
            fontSize: 18,
            fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(
            fontFamily: 'HindSiliguri',
            color: secondaryOnDark,
            fontSize: 16,
            height: 1.5,
            letterSpacing: 0.15),
        bodyMedium: TextStyle(
            fontFamily: 'HindSiliguri',
            color: secondaryOnDark,
            fontSize: 14,
            height: 1.5,
            letterSpacing: 0.15),
        labelLarge: TextStyle(
            fontFamily: 'HindSiliguri',
            color: textOnDark,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: sacredGold,
          foregroundColor: const Color(0xFF1A0A00),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton)),
          elevation: 8,
          shadowColor: sacredGold.withValues(alpha: 0.45),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface.withValues(alpha: 0.75),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: const BorderSide(color: sacredGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: const BorderSide(color: accentRed),
        ),
        labelStyle: const TextStyle(color: secondaryOnDark),
        hintStyle: const TextStyle(color: mutedOnDark),
      ),
      cardTheme: CardThemeData(
        color: darkSurface.withValues(alpha: 0.82),
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurface,
        contentTextStyle: const TextStyle(color: textOnDark),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard)),
      ),
    );
  }

  // ── Light Theme ──────────────────────────────────────────────────
  static ThemeData get lightTheme {
    const titleInk = Color(0xFF1A1A2E);
    const bodyInk = Color(0xFF4A4A5A);
    const mutedInk = Color(0xFF7A7A8A);

    final base = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: dawnBackground,
      fontFamily: 'HindSiliguri',
      fontFamilyFallback: const ['Roboto'],
      colorScheme: const ColorScheme.light(
        primary: vermillionDark,
        secondary: turmericGold,
        surface: dawnSurface,
        error: accentRed,
      ),
    );

    return base.copyWith(
      primaryColor: vermillionDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: titleInk),
        titleTextStyle: TextStyle(
          fontFamily: 'HindSiliguri',
          color: titleInk,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'HindSiliguri',
            color: titleInk,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5),
        displayMedium: TextStyle(
            fontFamily: 'HindSiliguri',
            color: titleInk,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5),
        displaySmall: TextStyle(
            fontFamily: 'HindSiliguri',
            color: titleInk,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5),
        headlineMedium: TextStyle(
            fontFamily: 'HindSiliguri',
            color: titleInk,
            fontSize: 18,
            fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(
            fontFamily: 'HindSiliguri',
            color: bodyInk,
            fontSize: 16,
            height: 1.5,
            letterSpacing: 0.15),
        bodyMedium: TextStyle(
            fontFamily: 'HindSiliguri',
            color: bodyInk,
            fontSize: 14,
            height: 1.5,
            letterSpacing: 0.15),
        labelLarge: TextStyle(
            fontFamily: 'HindSiliguri',
            color: titleInk,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vermillionDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton)),
          elevation: 3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.78),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: BorderSide(color: sacredGold.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: const BorderSide(color: vermillionDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusButton),
          borderSide: const BorderSide(color: accentRed),
        ),
        labelStyle: const TextStyle(color: bodyInk),
        hintStyle: const TextStyle(color: mutedInk),
      ),
      cardTheme: CardThemeData(
        color: dawnCardBg.withValues(alpha: 0.90),
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E3624),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusChip)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard)),
      ),
    );
  }
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration splash = Duration(milliseconds: 800);
}

class AppConstants {
  static const String appName = 'Durga Puja Donations';
  static const String appVersion = '2.0.0';
  static const String organizationName = 'Durga Puja Association';
  static const String contactEmail = 'contact@durgapuja.org';
  static const String contactPhone = '+91 98765 43210';
  static const String address = '123 Festival Lane, Kolkata, WB 700001';

  static const List<int> donationAmounts = [101, 251, 501, 1001, 2001, 5001];
  static const List<String> eventCategories = [
    'all',
    'religious',
    'cultural',
    'service',
    'celebration',
  ];
  static const List<String> galleryCategories = [
    'all',
    'idol',
    'celebration',
    'cultural',
    'community',
  ];
}
