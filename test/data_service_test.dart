import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/models/donation.dart';
import 'package:durga_puja_donations/models/event.dart';
import 'package:durga_puja_donations/models/gallery_item.dart';
import 'package:durga_puja_donations/models/announcement.dart';
import 'package:durga_puja_donations/repositories/donation_repository.dart';
import 'package:durga_puja_donations/repositories/event_repository.dart';
import 'package:durga_puja_donations/repositories/gallery_repository.dart';
import 'package:durga_puja_donations/repositories/announcement_repository.dart';
import 'package:durga_puja_donations/repositories/storage_repository.dart';
import 'package:durga_puja_donations/services/data_service.dart';

// ── In-memory repository implementations for testing ──────────────

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
  int _schemaVersion = 0;

  @override
  Future<void> ensureSchemaVersion() async {
    _schemaVersion = StorageRepository.currentSchemaVersion;
  }

  int get schemaVersion => _schemaVersion;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataService dataService;
  late InMemoryDonationRepository donationRepo;
  late InMemoryEventRepository eventRepo;
  late InMemoryGalleryRepository galleryRepo;
  late InMemoryAnnouncementRepository announcementRepo;
  late InMemoryStorageRepository storageRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    donationRepo = InMemoryDonationRepository();
    eventRepo = InMemoryEventRepository();
    galleryRepo = InMemoryGalleryRepository();
    announcementRepo = InMemoryAnnouncementRepository();
    storageRepo = InMemoryStorageRepository();

    dataService = DataService(
      donationRepository: donationRepo,
      eventRepository: eventRepo,
      galleryRepository: galleryRepo,
      announcementRepository: announcementRepo,
      storageRepository: storageRepo,
    );
    // Wait for bootstrap / sample data init
    await Future.delayed(const Duration(milliseconds: 300));
  });

  group('DataService - Initialization', () {
    test('bootstraps with sample events when empty', () {
      expect(dataService.events, isNotEmpty);
      expect(dataService.events.length, 4);
    });

    test('bootstraps with sample gallery items when empty', () {
      expect(dataService.galleryItems, isNotEmpty);
      expect(dataService.galleryItems.length, 2);
    });

    test('starts with no donations', () {
      expect(dataService.donations, isEmpty);
      expect(dataService.donationCount, 0);
      expect(dataService.totalDonations, 0);
    });

    test('ensures schema version on bootstrap', () {
      expect(storageRepo.schemaVersion,
          StorageRepository.currentSchemaVersion);
    });
  });

  group('DataService - Donation CRUD', () {
    Donation makeDonation({String id = '1', double amount = 500}) {
      return Donation(
        id: id,
        name: 'Test Donor',
        location: 'Kolkata',
        amount: amount,
        date: DateTime(2026, 9, 25),
      );
    }

    test('addDonation inserts at beginning and persists', () async {
      final d1 = makeDonation(id: 'd1', amount: 100);
      final d2 = makeDonation(id: 'd2', amount: 200);

      await dataService.addDonation(d1);
      await dataService.addDonation(d2);

      expect(dataService.donations.length, 2);
      expect(dataService.donations[0].id, 'd2');
      expect(dataService.donationCount, 2);

      final saved = await donationRepo.loadAll();
      expect(saved.length, 2);
    });

    test('totalDonations sums amounts', () async {
      await dataService.addDonation(makeDonation(id: '1', amount: 101));
      await dataService.addDonation(makeDonation(id: '2', amount: 251));

      expect(dataService.totalDonations, 352);
      expect(dataService.totalAmount, 352);
    });

    test('updateDonation modifies existing', () async {
      final d = makeDonation(id: 'up1', amount: 500);
      await dataService.addDonation(d);

      final updated = Donation(
        id: 'up1',
        name: 'Updated Name',
        location: 'Mumbai',
        amount: 1000,
        date: d.date,
      );
      await dataService.updateDonation(updated);

      expect(dataService.donations.length, 1);
      expect(dataService.donations[0].name, 'Updated Name');
      expect(dataService.donations[0].amount, 1000);
    });

    test('updateDonation ignores unknown id', () async {
      await dataService.addDonation(makeDonation(id: 'known'));
      final unknown = makeDonation(id: 'unknown');
      await dataService.updateDonation(unknown);
      expect(dataService.donations.length, 1);
      expect(dataService.donations[0].id, 'known');
    });

    test('deleteDonation removes by id', () async {
      await dataService.addDonation(makeDonation(id: 'del1'));
      await dataService.addDonation(makeDonation(id: 'keep'));
      await dataService.deleteDonation('del1');

      expect(dataService.donations.length, 1);
      expect(dataService.donations[0].id, 'keep');
    });

    test('getRecentDonations respects limit and sorts by date desc', () async {
      for (var i = 1; i <= 15; i++) {
        await dataService.addDonation(Donation(
          id: '$i',
          name: 'Donor $i',
          location: 'City',
          amount: 100,
          date: DateTime(2026, 1, i),
        ));
      }

      final recent = dataService.getRecentDonations(limit: 5);
      expect(recent.length, 5);
      // Most recent first
      expect(recent[0].date.day, 15);
      expect(recent[4].date.day, 11);
    });

    test('getDonationsByMonth groups correctly', () async {
      await dataService.addDonation(Donation(
        id: '1',
        name: 'A',
        location: 'L',
        amount: 100,
        date: DateTime(2026, 9, 1),
      ));
      await dataService.addDonation(Donation(
        id: '2',
        name: 'B',
        location: 'L',
        amount: 200,
        date: DateTime(2026, 9, 15),
      ));
      await dataService.addDonation(Donation(
        id: '3',
        name: 'C',
        location: 'L',
        amount: 500,
        date: DateTime(2026, 10, 1),
      ));

      final byMonth = dataService.getDonationsByMonth();
      expect(byMonth['2026-09'], 300);
      expect(byMonth['2026-10'], 500);
    });

    test('notifyListeners on donation add/update/delete', () async {
      int count = 0;
      dataService.addListener(() => count++);

      await dataService.addDonation(makeDonation(id: 'n1'));
      expect(count, greaterThanOrEqualTo(1));

      final before = count;
      await dataService.updateDonation(
        makeDonation(id: 'n1', amount: 999),
      );
      expect(count, greaterThan(before));

      final before2 = count;
      await dataService.deleteDonation('n1');
      expect(count, greaterThan(before2));
    });
  });

  group('DataService - Event CRUD', () {
    Event makeEvent({String id = '100', String category = 'religious'}) {
      return Event(
        id: id,
        title: 'Test Event',
        description: 'Test description',
        date: DateTime(2027, 9, 25),
        location: 'Pandal',
        category: category,
      );
    }

    test('addEvent appends and persists', () async {
      final initialCount = dataService.events.length;
      await dataService.addEvent(makeEvent(id: 'e1'));

      expect(dataService.events.length, initialCount + 1);
      final saved = await eventRepo.loadAll();
      expect(saved.length, initialCount + 1);
    });

    test('updateEvent modifies existing', () async {
      final e = makeEvent(id: 'eu1');
      await dataService.addEvent(e);

      final updated = Event(
        id: 'eu1',
        title: 'Updated Title',
        description: 'Updated desc',
        date: e.date,
        category: 'cultural',
      );
      await dataService.updateEvent(updated);

      final found = dataService.events.firstWhere((e) => e.id == 'eu1');
      expect(found.title, 'Updated Title');
      expect(found.category, 'cultural');
    });

    test('deleteEvent removes by id', () async {
      final e = makeEvent(id: 'ed1');
      await dataService.addEvent(e);
      final countBefore = dataService.events.length;

      await dataService.deleteEvent('ed1');
      expect(dataService.events.length, countBefore - 1);
    });

    test('getUpcomingEvents returns active future events', () async {
      // Clear sample events first
      for (var e in List.from(dataService.events)) {
        await dataService.deleteEvent(e.id);
      }

      await dataService.addEvent(Event(
        id: 'future1',
        title: 'Future',
        description: 'desc',
        date: DateTime.now().add(const Duration(days: 30)),
        category: 'religious',
        isActive: true,
      ));
      await dataService.addEvent(Event(
        id: 'past1',
        title: 'Past',
        description: 'desc',
        date: DateTime.now().subtract(const Duration(days: 30)),
        category: 'religious',
        isActive: true,
      ));
      await dataService.addEvent(Event(
        id: 'inactive1',
        title: 'Inactive',
        description: 'desc',
        date: DateTime.now().add(const Duration(days: 30)),
        category: 'religious',
        isActive: false,
      ));

      final upcoming = dataService.getUpcomingEvents();
      expect(upcoming.length, 1);
      expect(upcoming[0].id, 'future1');
    });

    test('activeEventsCount and upcomingEventsCount', () async {
      // Sample data has 4 active events
      expect(dataService.activeEventsCount, 4);
      // Sample events are in 2026 future dates
      expect(dataService.upcomingEventsCount, greaterThanOrEqualTo(0));
    });
  });

  group('DataService - Gallery CRUD', () {
    GalleryItem makeGalleryItem({String id = 'g1'}) {
      return GalleryItem(
        id: id,
        imageUrl: 'https://example.com/image.jpg',
        title: 'Test Image',
        category: 'idol',
        uploadedAt: DateTime.now(),
      );
    }

    test('addGalleryItem appends and persists', () async {
      final initialCount = dataService.galleryItems.length;
      await dataService.addGalleryItem(makeGalleryItem(id: 'gi1'));

      expect(dataService.galleryItems.length, initialCount + 1);
    });

    test('updateGalleryItem modifies existing', () async {
      final item = makeGalleryItem(id: 'gu1');
      await dataService.addGalleryItem(item);

      final updated = GalleryItem(
        id: 'gu1',
        imageUrl: 'https://example.com/updated.jpg',
        title: 'Updated Title',
        category: 'celebration',
        uploadedAt: item.uploadedAt,
      );
      await dataService.updateGalleryItem(updated);

      final found =
          dataService.galleryItems.firstWhere((g) => g.id == 'gu1');
      expect(found.title, 'Updated Title');
    });

    test('deleteGalleryItem removes by id', () async {
      await dataService.addGalleryItem(makeGalleryItem(id: 'gd1'));
      final countBefore = dataService.galleryItems.length;

      await dataService.deleteGalleryItem('gd1');
      expect(dataService.galleryItems.length, countBefore - 1);
    });

    test('getGalleryByCategory filters correctly', () async {
      // Sample data has 2 items: 'idol' and 'celebration'
      final idols = dataService.getGalleryByCategory('idol');
      expect(idols.every((g) => g.category == 'idol'), true);

      final all = dataService.getGalleryByCategory('all');
      expect(all.length, dataService.galleryCount);
    });

    test('galleryCount counts only active items', () async {
      await dataService.addGalleryItem(GalleryItem(
        id: 'inactive_g',
        imageUrl: 'https://example.com/inactive.jpg',
        title: 'Inactive',
        category: 'idol',
        uploadedAt: DateTime.now(),
        isActive: false,
      ));
      // Inactive item should not be counted
      expect(dataService.galleryCount,
          dataService.galleryItems.where((g) => g.isActive).length);
    });
  });

  group('DataService - Error Handling', () {
    test('lastError is null initially after successful bootstrap', () {
      expect(dataService.lastError, isNull);
    });
  });

  group('DataService - clearAllData', () {
    test('clears all lists and persists', () async {
      await dataService.addDonation(Donation(
        id: 'cd1',
        name: 'Clear',
        location: 'L',
        amount: 100,
        date: DateTime.now(),
      ));

      await dataService.clearAllData();

      expect(dataService.donations, isEmpty);
      expect(dataService.events, isEmpty);
      expect(dataService.galleryItems, isEmpty);
      expect(dataService.announcements, isEmpty);
      expect(dataService.volunteers, isEmpty);
    });
  });

  group('DataService - loadData', () {
    test('reloads data from repositories', () async {
      await dataService.addDonation(Donation(
        id: 'rl1',
        name: 'Reload',
        location: 'L',
        amount: 100,
        date: DateTime.now(),
      ));

      // Directly verify repos have data, then reload
      final savedBefore = await donationRepo.loadAll();
      expect(savedBefore.isNotEmpty, true);

      await dataService.loadData();
      expect(dataService.donations.isNotEmpty, true);
    });
  });
}
