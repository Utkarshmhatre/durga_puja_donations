import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/community_page.dart';
import 'package:durga_puja_donations/services/data_service.dart';
import 'package:durga_puja_donations/services/theme_service.dart';
import 'package:durga_puja_donations/src/localization/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CommunityPage', () {
    late DataService dataService;
    late ThemeService themeService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      dataService = DataService();
      themeService = ThemeService();
      // Wait for bootstrap
      await Future.delayed(const Duration(milliseconds: 200));
    });

    Widget buildTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<DataService>.value(value: dataService),
          ChangeNotifierProvider<ThemeService>.value(value: themeService),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CommunityPage(),
        ),
      );
    }

    // Use pump with duration instead of pumpAndSettle since animate_do
    // widgets use animations that never fully "settle"
    Future<void> pumpPage(WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      // Pump enough frames for animations to render content
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('renders CommunityPage without error', (tester) async {
      await pumpPage(tester);
      expect(find.byType(CommunityPage), findsOneWidget);
    });

    testWidgets('displays section headers', (tester) async {
      await pumpPage(tester);

      // Check for main sections - using English l10n
      expect(find.text('Announcements'), findsOneWidget);
    });

    testWidgets('shows empty state for announcements', (tester) async {
      await pumpPage(tester);

      // Should show empty state message
      expect(find.text('No announcements yet'), findsOneWidget);
    });

    testWidgets('volunteer form is present', (tester) async {
      // Use a large screen to show volunteer section without scrolling
      tester.view.physicalSize = const Size(1080, 5000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);

      expect(find.text('Volunteer Registration'), findsOneWidget);
    });

    testWidgets('emergency contacts section is present', (tester) async {
      // Use a large screen to show all sections without scrolling
      tester.view.physicalSize = const Size(1080, 8000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);

      expect(find.text('Emergency Contacts'), findsOneWidget);
    });
  });
}
