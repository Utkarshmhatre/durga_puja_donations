import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/home_page.dart';
import 'package:durga_puja_donations/services/data_service.dart';
import 'package:durga_puja_donations/services/theme_service.dart';
import 'package:durga_puja_donations/services/auth_service.dart';
import 'package:durga_puja_donations/services/app_settings_service.dart';
import 'package:durga_puja_donations/src/localization/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomePage', () {
    late DataService dataService;
    late ThemeService themeService;
    late AuthService authService;
    late AppSettingsService appSettingsService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      dataService = DataService();
      themeService = ThemeService();
      authService = AuthService();
      appSettingsService = AppSettingsService();
      await appSettingsService.load();
      await Future.delayed(const Duration(milliseconds: 300));
    });

    Widget buildTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<DataService>.value(value: dataService),
          ChangeNotifierProvider<ThemeService>.value(value: themeService),
          ChangeNotifierProvider<AuthService>.value(value: authService),
          ChangeNotifierProvider<AppSettingsService>.value(
              value: appSettingsService),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomePage(),
        ),
      );
    }

    Future<void> pumpPage(WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('renders HomePage without error', (tester) async {
      await pumpPage(tester);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('displays welcome section', (tester) async {
      await pumpPage(tester);
      expect(find.text('Welcome to'), findsOneWidget);
      expect(find.text('Durga Puja 2026'), findsOneWidget);
    });

    testWidgets('displays app bar title', (tester) async {
      await pumpPage(tester);
      expect(find.text('Durga Puja'), findsOneWidget);
    });

    testWidgets('displays quick stats section', (tester) async {
      await pumpPage(tester);
      expect(find.text('Donations'), findsOneWidget);
      expect(find.text('Collected'), findsOneWidget);
      expect(find.text('Events'), findsWidgets);
    });

    testWidgets('displays Quick Actions heading', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);
      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('displays feature cards', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);

      // Feature cards
      expect(find.text('Donate'), findsWidgets); // title + FAB label
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Trivia'), findsOneWidget);
    });

    testWidgets('displays floating donate button', (tester) async {
      await pumpPage(tester);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('has menu icon for drawer', (tester) async {
      await pumpPage(tester);
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    });

    testWidgets('opens drawer on menu tap', (tester) async {
      tester.view.physicalSize = const Size(1080, 6000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pump(const Duration(seconds: 1));

      // Drawer items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings', skipOffstage: false), findsOneWidget);
      expect(find.text('Admin', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Upcoming Events section exists', (tester) async {
      tester.view.physicalSize = const Size(1080, 6000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);
      expect(find.text('Upcoming Events'), findsOneWidget);
    });

    testWidgets('copyright text in drawer', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('© 2026 Durga Puja Committee'), findsOneWidget);
    });
  });
}
