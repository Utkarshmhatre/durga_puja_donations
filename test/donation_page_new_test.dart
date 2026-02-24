import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/donation_page_new.dart';
import 'package:durga_puja_donations/services/data_service.dart';
import 'package:durga_puja_donations/services/theme_service.dart';
import 'package:durga_puja_donations/src/localization/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DonationPageNew', () {
    late DataService dataService;
    late ThemeService themeService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      dataService = DataService();
      themeService = ThemeService();
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
          home: DonationPageNew(),
        ),
      );
    }

    Future<void> pumpPage(WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('renders DonationPageNew without error', (tester) async {
      await pumpPage(tester);
      expect(find.byType(DonationPageNew), findsOneWidget);
    });

    testWidgets('displays page title', (tester) async {
      await pumpPage(tester);
      expect(find.text('Make a Donation'), findsOneWidget);
    });

    testWidgets('displays form fields', (tester) async {
      await pumpPage(tester);
      expect(find.text('Full Name *'), findsOneWidget);
      expect(find.text('Location *'), findsOneWidget);
      expect(find.text('Phone (Optional)'), findsOneWidget);
      expect(find.text('Email (Optional)'), findsOneWidget);
    });

    testWidgets('displays amount buttons', (tester) async {
      await pumpPage(tester);
      expect(find.text('Rs. 101'), findsOneWidget);
      expect(find.text('Rs. 251'), findsOneWidget);
      expect(find.text('Rs. 501'), findsOneWidget);
      expect(find.text('Rs. 1001'), findsOneWidget);
    });

    testWidgets('displays choose amount header', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);
      expect(find.text('Choose Donation Amount'), findsOneWidget);
    });

    testWidgets('selecting an amount button highlights it', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);

      await tester.tap(find.text('Rs. 501'));
      await tester.pump(const Duration(milliseconds: 300));

      // After selecting amount, a donate button for that amount should appear
      expect(find.text('Donate Rs. 501'), findsOneWidget);
    });

    testWidgets('can enter text in name field', (tester) async {
      await pumpPage(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name *'),
        'Rina Das',
      );
      await tester.pump();

      expect(find.text('Rina Das'), findsOneWidget);
    });

    testWidgets('custom amount field exists', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpPage(tester);
      expect(find.text('Custom Amount'), findsOneWidget);
    });

    testWidgets('has back button', (tester) async {
      await pumpPage(tester);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
