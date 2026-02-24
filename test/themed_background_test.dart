import 'package:durga_puja_donations/services/theme_service.dart';
import 'package:durga_puja_donations/widgets/backgrounds/dark_firefly_background.dart';
import 'package:durga_puja_donations/widgets/backgrounds/dawn_rays_background.dart';
import 'package:durga_puja_donations/widgets/backgrounds/themed_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pump(
    WidgetTester tester, {
    required ThemeMode mode,
  }) async {
    SharedPreferences.setMockInitialValues({
      'app_theme_mode': mode == ThemeMode.dark ? 'dark' : 'light',
      'app_theme_variant': mode == ThemeMode.dark ? 'mahakaliNight' : 'subhoDawn',
      'app_reduced_motion': false,
    });

    final service = ThemeService();
    await service.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: service,
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: service.themeMode,
          home: const Scaffold(
            body: ThemedBackground(
              child: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders dark firefly background in dark mode', (tester) async {
    await pump(tester, mode: ThemeMode.dark);
    expect(find.byType(DarkFireflyBackground), findsOneWidget);
    expect(find.byType(DawnRaysBackground), findsNothing);
  });

  testWidgets('renders dawn rays background in light mode', (tester) async {
    await pump(tester, mode: ThemeMode.light);
    expect(find.byType(DawnRaysBackground), findsOneWidget);
    expect(find.byType(DarkFireflyBackground), findsNothing);
  });
}
