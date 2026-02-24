import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/models/donation.dart';
import 'package:durga_puja_donations/repositories/donation_repository.dart';
import 'package:durga_puja_donations/repositories/event_repository.dart';
import 'package:durga_puja_donations/repositories/gallery_repository.dart';
import 'package:durga_puja_donations/repositories/announcement_repository.dart';
import 'package:durga_puja_donations/repositories/storage_repository.dart';
import 'package:durga_puja_donations/models/announcement.dart';
import 'package:durga_puja_donations/models/event.dart';
import 'package:durga_puja_donations/models/gallery_item.dart';
import 'package:durga_puja_donations/services/data_service.dart';
import 'package:durga_puja_donations/services/theme_service.dart';
import 'package:durga_puja_donations/services/auth_service.dart';
import 'package:durga_puja_donations/services/app_settings_service.dart';
import 'package:durga_puja_donations/home_page.dart';
import 'package:durga_puja_donations/src/localization/app_localizations.dart';

// ── In-memory repositories for integration test ──────────────────

class InMemoryDonationRepository implements DonationRepository {
  List<Donation> _data = [];

  @override
  Future<List<Donation>> loadAll() async => List.from(_data);

  @override
  Future<void> saveAll(List<Donation> items) async {
    _data = List.from(items);
  }
}

class InMemoryEventRepository implements EventRepository {
  List<Event> _data = [];

  @override
  Future<List<Event>> loadAll() async => List.from(_data);

  @override
  Future<void> saveAll(List<Event> items) async {
    _data = List.from(items);
  }
}

class InMemoryGalleryRepository implements GalleryRepository {
  List<GalleryItem> _data = [];

  @override
  Future<List<GalleryItem>> loadAll() async => List.from(_data);

  @override
  Future<void> saveAll(List<GalleryItem> items) async {
    _data = List.from(items);
  }
}

class InMemoryAnnouncementRepository implements AnnouncementRepository {
  List<Announcement> _announcements = [];
  List<VolunteerRegistration> _volunteers = [];

  @override
  Future<List<Announcement>> loadAll() async => List.from(_announcements);

  @override
  Future<void> saveAll(List<Announcement> items) async {
    _announcements = List.from(items);
  }

  @override
  Future<List<VolunteerRegistration>> loadVolunteers() async =>
      List.from(_volunteers);

  @override
  Future<void> saveVolunteers(List<VolunteerRegistration> items) async {
    _volunteers = List.from(items);
  }
}

class InMemoryStorageRepository extends StorageRepository {
  @override
  Future<void> ensureSchemaVersion() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Donation Flow Integration', () {
    late DataService dataService;
    late ThemeService themeService;
    late AuthService authService;
    late AppSettingsService appSettingsService;
    late InMemoryDonationRepository donationRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      donationRepo = InMemoryDonationRepository();
      dataService = DataService(
        donationRepository: donationRepo,
        eventRepository: InMemoryEventRepository(),
        galleryRepository: InMemoryGalleryRepository(),
        announcementRepository: InMemoryAnnouncementRepository(),
        storageRepository: InMemoryStorageRepository(),
      );
      themeService = ThemeService();
      authService = AuthService();
      appSettingsService = AppSettingsService();
      await appSettingsService.load();
      await Future.delayed(const Duration(milliseconds: 300));
    });

    Widget buildTestApp() {
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

    testWidgets('Home → Donate page navigation', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Tap the floating donate button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Should reach the Donation page
      expect(find.text('Make a Donation'), findsOneWidget);
    });

    testWidgets('Fill donation form and select amount', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestApp());
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Navigate to donation page
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Fill the form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name *'),
        'Amit Kumar',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Location *'),
        'Kolkata',
      );
      await tester.pump();

      // Select an amount
      await tester.tap(find.text('Rs. 501'));
      await tester.pump(const Duration(milliseconds: 300));

      // The selected amount button should appear
      expect(find.text('Donate Rs. 501'), findsOneWidget);
    });

    testWidgets('DataService donation add updates stats on home',
        (tester) async {
      // Add a donation directly through DataService
      await dataService.addDonation(Donation(
        id: 'int1',
        name: 'Test Donor',
        location: 'Mumbai',
        amount: 1001,
        date: DateTime.now(),
      ));

      expect(dataService.donationCount, 1);
      expect(dataService.totalDonations, 1001);

      // Verify repository was updated
      final saved = await donationRepo.loadAll();
      expect(saved.length, 1);
      expect(saved[0].name, 'Test Donor');
    });

    testWidgets('Multiple donations accumulate correctly', (tester) async {
      await dataService.addDonation(Donation(
        id: 'multi1',
        name: 'Donor A',
        location: 'Delhi',
        amount: 500,
        date: DateTime(2026, 9, 1),
      ));
      await dataService.addDonation(Donation(
        id: 'multi2',
        name: 'Donor B',
        location: 'Kolkata',
        amount: 1000,
        date: DateTime(2026, 9, 15),
      ));
      await dataService.addDonation(Donation(
        id: 'multi3',
        name: 'Donor C',
        location: 'Mumbai',
        amount: 2500,
        date: DateTime(2026, 10, 1),
      ));

      expect(dataService.donationCount, 3);
      expect(dataService.totalDonations, 4000);

      // Recent donations should be sorted
      final recent = dataService.getRecentDonations(limit: 2);
      expect(recent.length, 2);
      expect(recent[0].date.isAfter(recent[1].date), true);

      // Monthly breakdown
      final monthly = dataService.getDonationsByMonth();
      expect(monthly['2026-09'], 1500);
      expect(monthly['2026-10'], 2500);
    });

    testWidgets('Delete donation reflects in stats', (tester) async {
      await dataService.addDonation(Donation(
        id: 'del_int',
        name: 'To Delete',
        location: 'L',
        amount: 999,
        date: DateTime.now(),
      ));
      expect(dataService.donationCount, 1);

      await dataService.deleteDonation('del_int');
      expect(dataService.donationCount, 0);
      expect(dataService.totalDonations, 0);
    });
  });
}
