import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeVariant {
  mahakaliNight,
  subhoDawn,
}

class ThemeService extends ChangeNotifier {
  static const String _themeModeKey = 'app_theme_mode';
  static const String _themeVariantKey = 'app_theme_variant';
  static const String _reducedMotionKey = 'app_reduced_motion';

  ThemeMode _themeMode = ThemeMode.dark;
  ThemeVariant _variant = ThemeVariant.mahakaliNight;
  bool _reducedMotion = false;

  ThemeMode get themeMode => _themeMode;
  ThemeVariant get variant => _variant;
  bool get reducedMotion => _reducedMotion;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeRaw = prefs.getString(_themeModeKey);
    final variantRaw = prefs.getString(_themeVariantKey);
    final reducedMotionRaw = prefs.getBool(_reducedMotionKey);

    _themeMode = _deserializeThemeMode(modeRaw);
    _variant = _deserializeVariant(variantRaw);
    _reducedMotion = reducedMotionRaw ?? false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _variant = mode == ThemeMode.dark
        ? ThemeVariant.mahakaliNight
        : ThemeVariant.subhoDawn;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _serializeThemeMode(mode));
    await prefs.setString(_themeVariantKey, _serializeVariant(_variant));
  }

  Future<void> toggleTheme() async {
    final nextMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }

  Future<void> setReducedMotion(bool value) async {
    if (_reducedMotion == value) return;
    _reducedMotion = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reducedMotionKey, value);
  }

  ThemeMode _deserializeThemeMode(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  ThemeVariant _deserializeVariant(String? raw) {
    switch (raw) {
      case 'subhoDawn':
        return ThemeVariant.subhoDawn;
      case 'mahakaliNight':
      default:
        return ThemeVariant.mahakaliNight;
    }
  }

  String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
      default:
        return 'dark';
    }
  }

  String _serializeVariant(ThemeVariant variant) {
    switch (variant) {
      case ThemeVariant.subhoDawn:
        return 'subhoDawn';
      case ThemeVariant.mahakaliNight:
        return 'mahakaliNight';
    }
  }
}
