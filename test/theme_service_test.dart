import 'package:durga_puja_donations/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeService', () {
    test('load reads persisted theme and reduced motion', () async {
      SharedPreferences.setMockInitialValues({
        'app_theme_mode': 'light',
        'app_theme_variant': 'subhoDawn',
        'app_reduced_motion': true,
      });

      final service = ThemeService();
      await service.load();

      expect(service.themeMode, ThemeMode.light);
      expect(service.variant, ThemeVariant.subhoDawn);
      expect(service.reducedMotion, true);
    });

    test('toggleTheme switches mode and persists', () async {
      SharedPreferences.setMockInitialValues({
        'app_theme_mode': 'dark',
        'app_theme_variant': 'mahakaliNight',
      });

      final service = ThemeService();
      await service.load();
      await service.toggleTheme();

      expect(service.themeMode, ThemeMode.light);
      expect(service.variant, ThemeVariant.subhoDawn);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'light');
      expect(prefs.getString('app_theme_variant'), 'subhoDawn');
    });
  });
}
