import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/events_page_new.dart';
import 'package:durga_puja_donations/services/data_service.dart';
import 'package:durga_puja_donations/services/app_settings_service.dart';
import 'package:durga_puja_donations/services/theme_service.dart';
import 'package:durga_puja_donations/src/localization/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EventsPageNew', () {
    late DataService dataService;
    late AppSettingsService appSettingsService;
    late ThemeService themeService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      dataService = DataService();
      appSettingsService = AppSettingsService();
      themeService = ThemeService();
      await appSettingsService.load();
      await Future.delayed(const Duration(milliseconds: 200));
    });

    Widget buildTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<DataService>.value(value: dataService),
          ChangeNotifierProvider<AppSettingsService>.value(
              value: appSettingsService),
          ChangeNotifierProvider<ThemeService>.value(value: themeService),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EventsPageNew(),
        ),
      );
    }

    Future<void> pumpPage(WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('renders EventsPageNew without error', (tester) async {
      await pumpPage(tester);
      expect(find.byType(EventsPageNew), findsOneWidget);
    });

    testWidgets('displays page title', (tester) async {
      await pumpPage(tester);
      expect(find.text('Events'), findsOneWidget);
    });

    testWidgets('displays category filter chips', (tester) async {
      await pumpPage(tester);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Religious'), findsOneWidget);
      expect(find.text('Cultural'), findsOneWidget);
      expect(find.text('Service'), findsOneWidget);
      expect(find.text('Celebration'), findsOneWidget);
    });

    testWidgets('displays upcoming events count', (tester) async {
      await pumpPage(tester);
      // Sample events exist, so count should show
      final countFinder = find.textContaining('Upcoming');
      expect(countFinder, findsOneWidget);
    });

    testWidgets('displays calendar widget', (tester) async {
      await pumpPage(tester);
      // TableCalendar renders day numbers
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('has back button', (tester) async {
      await pumpPage(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays event cards from sample data', (tester) async {
      tester.view.physicalSize = const Size(1080, 6000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);

      // Sample data has events like 'Durga Puja Mahalaya'
      expect(find.text('Durga Puja Mahalaya'), findsOneWidget);
    });

    testWidgets('category chip tap filters events', (tester) async {
      tester.view.physicalSize = const Size(1080, 6000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);

      // Tap 'Service' category
      await tester.tap(find.text('Service'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Should show 'Community Service Day'
      expect(find.text('Community Service Day'), findsOneWidget);
      // Should not show 'Cultural Night' (different category)
      expect(find.text('Cultural Night'), findsNothing);
    });
  });
}
