import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/models/announcement.dart';
import 'package:durga_puja_donations/repositories/announcement_repository.dart';
import 'package:durga_puja_donations/services/data_service.dart';

/// In-memory implementation for testing
class InMemoryAnnouncementRepository implements AnnouncementRepository {
  List<Announcement> _announcements = [];
  List<VolunteerRegistration> _volunteers = [];

  @override
  Future<List<Announcement>> loadAll() async => List.from(_announcements);

  @override
  Future<void> saveAll(List<Announcement> announcements) async {
    _announcements = List.from(announcements);
  }

  @override
  Future<List<VolunteerRegistration>> loadVolunteers() async =>
      List.from(_volunteers);

  @override
  Future<void> saveVolunteers(List<VolunteerRegistration> volunteers) async {
    _volunteers = List.from(volunteers);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DataService - Community CRUD', () {
    late DataService dataService;
    late InMemoryAnnouncementRepository announcementRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      announcementRepo = InMemoryAnnouncementRepository();
      dataService = DataService(
        announcementRepository: announcementRepo,
      );
      // Wait for bootstrap to complete
      await Future.delayed(const Duration(milliseconds: 200));
    });

    group('Announcements', () {
      test('starts with empty announcements', () {
        expect(dataService.announcements, isEmpty);
      });

      test('addAnnouncement inserts at beginning', () async {
        final a1 = Announcement(
          id: 'a1',
          title: 'First',
          body: 'First body',
          createdAt: DateTime(2026, 9, 25),
        );
        final a2 = Announcement(
          id: 'a2',
          title: 'Second',
          body: 'Second body',
          createdAt: DateTime(2026, 9, 26),
        );

        await dataService.addAnnouncement(a1);
        await dataService.addAnnouncement(a2);

        expect(dataService.announcements.length, 2);
        expect(dataService.announcements[0].id, 'a2'); // Most recent first
        expect(dataService.announcements[1].id, 'a1');
      });

      test('addAnnouncement persists to repository', () async {
        final a = Announcement(
          id: 'persist1',
          title: 'Persisted',
          body: 'Body',
          createdAt: DateTime(2026, 9, 25),
        );

        await dataService.addAnnouncement(a);

        final saved = await announcementRepo.loadAll();
        expect(saved.length, 1);
        expect(saved[0].id, 'persist1');
      });

      test('updateAnnouncement modifies existing', () async {
        final a = Announcement(
          id: 'upd1',
          title: 'Original',
          body: 'Original body',
          createdAt: DateTime(2026, 9, 25),
        );

        await dataService.addAnnouncement(a);
        await dataService.updateAnnouncement(
          a.copyWith(title: 'Updated', isPinned: true),
        );

        expect(dataService.announcements.length, 1);
        expect(dataService.announcements[0].title, 'Updated');
        expect(dataService.announcements[0].isPinned, true);
      });

      test('updateAnnouncement does nothing for unknown id', () async {
        final a = Announcement(
          id: 'known',
          title: 'Known',
          body: 'Body',
          createdAt: DateTime(2026, 9, 25),
        );
        await dataService.addAnnouncement(a);

        final unknown = Announcement(
          id: 'unknown',
          title: 'Unknown',
          body: 'Body',
          createdAt: DateTime(2026, 9, 26),
        );
        await dataService.updateAnnouncement(unknown);

        expect(dataService.announcements.length, 1);
        expect(dataService.announcements[0].id, 'known');
      });

      test('deleteAnnouncement removes by id', () async {
        final a1 = Announcement(
          id: 'del1',
          title: 'To Delete',
          body: 'Body',
          createdAt: DateTime(2026, 9, 25),
        );
        final a2 = Announcement(
          id: 'keep1',
          title: 'To Keep',
          body: 'Body',
          createdAt: DateTime(2026, 9, 26),
        );

        await dataService.addAnnouncement(a1);
        await dataService.addAnnouncement(a2);
        await dataService.deleteAnnouncement('del1');

        expect(dataService.announcements.length, 1);
        expect(dataService.announcements[0].id, 'keep1');
      });

      test('deleteAnnouncement persists to repository', () async {
        final a = Announcement(
          id: 'delpersist',
          title: 'Delete Persist',
          body: 'Body',
          createdAt: DateTime(2026, 9, 25),
        );

        await dataService.addAnnouncement(a);
        await dataService.deleteAnnouncement('delpersist');

        final saved = await announcementRepo.loadAll();
        expect(saved, isEmpty);
      });

      test('notifyListeners called on announcement operations', () async {
        int callCount = 0;
        dataService.addListener(() => callCount++);

        await dataService.addAnnouncement(Announcement(
          id: 'n1',
          title: 'Test',
          body: 'Body',
          createdAt: DateTime(2026, 9, 25),
        ));
        expect(callCount, greaterThanOrEqualTo(1));

        final before = callCount;
        await dataService.updateAnnouncement(Announcement(
          id: 'n1',
          title: 'Updated',
          body: 'Body',
          createdAt: DateTime(2026, 9, 25),
        ));
        expect(callCount, greaterThan(before));

        final before2 = callCount;
        await dataService.deleteAnnouncement('n1');
        expect(callCount, greaterThan(before2));
      });
    });

    group('Volunteers', () {
      test('starts with empty volunteers', () {
        expect(dataService.volunteers, isEmpty);
      });

      test('addVolunteer inserts at beginning', () async {
        final v1 = VolunteerRegistration(
          id: 'v1',
          name: 'Rina Das',
          phone: '9876543210',
          registeredAt: DateTime(2026, 9, 25),
        );
        final v2 = VolunteerRegistration(
          id: 'v2',
          name: 'Amit Ghosh',
          phone: '1234567890',
          registeredAt: DateTime(2026, 9, 26),
        );

        await dataService.addVolunteer(v1);
        await dataService.addVolunteer(v2);

        expect(dataService.volunteers.length, 2);
        expect(dataService.volunteers[0].id, 'v2'); // Most recent first
        expect(dataService.volunteers[1].id, 'v1');
      });

      test('addVolunteer persists to repository', () async {
        await dataService.addVolunteer(VolunteerRegistration(
          id: 'vp1',
          name: 'Vol Persist',
          phone: '5555555555',
          registeredAt: DateTime(2026, 9, 25),
        ));

        final saved = await announcementRepo.loadVolunteers();
        expect(saved.length, 1);
        expect(saved[0].id, 'vp1');
      });

      test('deleteVolunteer removes by id', () async {
        await dataService.addVolunteer(VolunteerRegistration(
          id: 'vdel',
          name: 'To Delete',
          phone: '1111111111',
          registeredAt: DateTime(2026, 9, 25),
        ));
        await dataService.addVolunteer(VolunteerRegistration(
          id: 'vkeep',
          name: 'To Keep',
          phone: '2222222222',
          registeredAt: DateTime(2026, 9, 26),
        ));

        await dataService.deleteVolunteer('vdel');

        expect(dataService.volunteers.length, 1);
        expect(dataService.volunteers[0].id, 'vkeep');
      });

      test('notifyListeners called on volunteer operations', () async {
        int callCount = 0;
        dataService.addListener(() => callCount++);

        await dataService.addVolunteer(VolunteerRegistration(
          id: 'vn1',
          name: 'Test Vol',
          phone: '3333333333',
          registeredAt: DateTime(2026, 9, 25),
        ));
        expect(callCount, greaterThanOrEqualTo(1));

        final before = callCount;
        await dataService.deleteVolunteer('vn1');
        expect(callCount, greaterThan(before));
      });
    });
  });
}
