import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:durga_puja_donations/repositories/announcement_repository.dart';
import 'package:durga_puja_donations/models/announcement.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPrefsAnnouncementRepository', () {
    late SharedPrefsAnnouncementRepository repo;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repo = SharedPrefsAnnouncementRepository();
    });

    group('Announcements', () {
      test('loadAll returns empty list when no data', () async {
        final result = await repo.loadAll();
        expect(result, isEmpty);
      });

      test('saveAll and loadAll roundtrip', () async {
        final announcements = [
          Announcement(
            id: 'a1',
            title: 'First',
            body: 'First body',
            category: 'general',
            createdAt: DateTime(2026, 9, 25),
          ),
          Announcement(
            id: 'a2',
            title: 'Second',
            body: 'Second body',
            category: 'emergency',
            createdAt: DateTime(2026, 9, 26),
            isPinned: true,
          ),
        ];

        await repo.saveAll(announcements);
        final loaded = await repo.loadAll();

        expect(loaded.length, 2);
        expect(loaded[0].id, 'a1');
        expect(loaded[0].title, 'First');
        expect(loaded[1].id, 'a2');
        expect(loaded[1].category, 'emergency');
        expect(loaded[1].isPinned, true);
      });

      test('saveAll overwrites previous data', () async {
        await repo.saveAll([
          Announcement(
            id: 'old',
            title: 'Old',
            body: 'Old body',
            createdAt: DateTime(2026, 9, 20),
          ),
        ]);

        await repo.saveAll([
          Announcement(
            id: 'new',
            title: 'New',
            body: 'New body',
            createdAt: DateTime(2026, 9, 25),
          ),
        ]);

        final loaded = await repo.loadAll();
        expect(loaded.length, 1);
        expect(loaded[0].id, 'new');
      });

      test('saveAll empty list clears data', () async {
        await repo.saveAll([
          Announcement(
            id: 'a1',
            title: 'Test',
            body: 'Body',
            createdAt: DateTime(2026, 9, 25),
          ),
        ]);
        await repo.saveAll([]);
        final loaded = await repo.loadAll();
        expect(loaded, isEmpty);
      });
    });

    group('Volunteers', () {
      test('loadVolunteers returns empty list when no data', () async {
        final result = await repo.loadVolunteers();
        expect(result, isEmpty);
      });

      test('saveVolunteers and loadVolunteers roundtrip', () async {
        final volunteers = [
          VolunteerRegistration(
            id: 'v1',
            name: 'Rina Das',
            phone: '9876543210',
            availability: 'morning',
            registeredAt: DateTime(2026, 9, 25),
          ),
          VolunteerRegistration(
            id: 'v2',
            name: 'Amit Ghosh',
            phone: '1234567890',
            availability: 'fullDay',
            registeredAt: DateTime(2026, 9, 26),
          ),
        ];

        await repo.saveVolunteers(volunteers);
        final loaded = await repo.loadVolunteers();

        expect(loaded.length, 2);
        expect(loaded[0].id, 'v1');
        expect(loaded[0].name, 'Rina Das');
        expect(loaded[0].availability, 'morning');
        expect(loaded[1].id, 'v2');
        expect(loaded[1].name, 'Amit Ghosh');
      });

      test('saveVolunteers overwrites previous data', () async {
        await repo.saveVolunteers([
          VolunteerRegistration(
            id: 'old',
            name: 'Old Vol',
            phone: '1111111111',
            registeredAt: DateTime(2026, 9, 20),
          ),
        ]);

        await repo.saveVolunteers([
          VolunteerRegistration(
            id: 'new',
            name: 'New Vol',
            phone: '2222222222',
            registeredAt: DateTime(2026, 9, 25),
          ),
        ]);

        final loaded = await repo.loadVolunteers();
        expect(loaded.length, 1);
        expect(loaded[0].id, 'new');
      });
    });

    test('announcements and volunteers are independent', () async {
      await repo.saveAll([
        Announcement(
          id: 'a1',
          title: 'Ann',
          body: 'Body',
          createdAt: DateTime(2026, 9, 25),
        ),
      ]);
      await repo.saveVolunteers([
        VolunteerRegistration(
          id: 'v1',
          name: 'Vol',
          phone: '5555555555',
          registeredAt: DateTime(2026, 9, 25),
        ),
      ]);

      final announcements = await repo.loadAll();
      final volunteers = await repo.loadVolunteers();

      expect(announcements.length, 1);
      expect(volunteers.length, 1);
      expect(announcements[0].id, 'a1');
      expect(volunteers[0].id, 'v1');
    });
  });
}
