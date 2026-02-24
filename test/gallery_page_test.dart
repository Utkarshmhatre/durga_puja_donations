import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:durga_puja_donations/gallery_page_new.dart';
import 'package:durga_puja_donations/services/data_service.dart';
import 'package:durga_puja_donations/src/localization/app_localizations.dart';

void main() {
  testWidgets('GalleryPageNew renders with DataService provider',
      (WidgetTester tester) async {
    final dataService = DataService();

    await tester.pumpWidget(
      ChangeNotifierProvider<DataService>.value(
        value: dataService,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GalleryPageNew(),
        ),
      ),
    );
    // Use pump with a fixed duration instead of pumpAndSettle because
    // animate_do animations (FadeInDown) never fully settle.
    await tester.pump(const Duration(seconds: 2));

    // Verify that the gallery page is displayed
    expect(find.byType(GalleryPageNew), findsOneWidget);
  });
}
