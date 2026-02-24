import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:durga_puja_donations/repositories/hive_adapters.dart';
import 'package:durga_puja_donations/repositories/hive_announcement_repository.dart';
import 'package:durga_puja_donations/models/announcement.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_announcement_test_');
    Hive.init(tempDir.path);
    registerHiveAdapters();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUp(() async {
    if (Hive.isBoxOpen(HiveAnnouncementRepository.announcementsBoxName)) {
      await Hive.box<Announcement>(
              HiveAnnouncementRepository.announcementsBoxName)
          .clear();
    }
    if (Hive.isBoxOpen(HiveAnnouncementRepository.volunteersBoxName)) {
      await Hive.box<VolunteerRegistration>(
              HiveAnnouncementRepository.volunteersBoxName)
          .clear();
    }
  });

  group('HiveAnnouncementRepository', () {
    group('Announcements', () {
      test('loadAll returns empty list when no data', () async {
        final repo = HiveAnnouncementRepository();
        final result = await repo.loadAll();
        expect(result, isEmpty);
      });

      test('saveAll and loadAll roundtrip', () async {
        final repo = HiveAnnouncementRepository();
        final announcements = [
          Announcement(
            id: 'a1',
            title: 'Welcome',
            body: 'Welcome to the festival',
            category: 'general',
            createdAt: DateTime(2026, 9, 20),
            isPinned: true,
          ),
          Announcement(
            id: 'a2',
            title: 'Bhog Timing',
            body: 'Bhog at 12 PM',
            category: 'bhog',
            createdAt: DateTime(2026, 9, 21),
          ),
        ];

        await repo.saveAll(announcements);
        final loaded = await repo.loadAll();

        expect(loaded.length, 2);
        expect(loaded.any((a) => a.id == 'a1' && a.isPinned), true);
        expect(loaded.any((a) => a.id == 'a2' && a.category == 'bhog'), true);
      });

      test('putAnnouncement and deleteAnnouncement', () async {
        final repo = HiveAnnouncementRepository();
        final announcement = Announcement(
          id: 'a3',
          title: 'Emergency',
          body: 'First aid at Gate 2',
          category: 'emergency',
          createdAt: DateTime(2026, 9, 22),
        );

        await repo.putAnnouncement(announcement);
        var loaded = await repo.loadAll();
        expect(loaded.length, 1);
        expect(loaded[0].title, 'Emergency');

        await repo.deleteAnnouncement('a3');
        loaded = await repo.loadAll();
        expect(loaded, isEmpty);
      });
    });

    group('Volunteers', () {
      test('loadVolunteers returns empty list when no data', () async {
        final repo = HiveAnnouncementRepository();
        final result = await repo.loadVolunteers();
        expect(result, isEmpty);
      });

      test('saveVolunteers and loadVolunteers roundtrip', () async {
        final repo = HiveAnnouncementRepository();
        final volunteers = [
          VolunteerRegistration(
            id: 'v1',
            name: 'Ravi',
            phone: '9876543210',
            availability: 'morning',
            registeredAt: DateTime(2026, 9, 20),
          ),
          VolunteerRegistration(
            id: 'v2',
            name: 'Priya',
            phone: '9988776655',
            availability: 'fullDay',
            registeredAt: DateTime(2026, 9, 21),
          ),
        ];

        await repo.saveVolunteers(volunteers);
        final loaded = await repo.loadVolunteers();

        expect(loaded.length, 2);
        expect(loaded.any((v) => v.name == 'Ravi'), true);
        expect(loaded.any((v) => v.name == 'Priya'), true);
      });

      test('putVolunteer and deleteVolunteer', () async {
        final repo = HiveAnnouncementRepository();
        final volunteer = VolunteerRegistration(
          id: 'v3',
          name: 'Amit',
          phone: '1234567890',
          registeredAt: DateTime(2026, 9, 22),
        );

        await repo.putVolunteer(volunteer);
        var loaded = await repo.loadVolunteers();
        expect(loaded.length, 1);

        await repo.deleteVolunteer('v3');
        loaded = await repo.loadVolunteers();
        expect(loaded, isEmpty);
      });
    });

    test('announcements and volunteers are independent', () async {
      final repo = HiveAnnouncementRepository();

      await repo.putAnnouncement(Announcement(
        id: 'a1',
        title: 'Test',
        body: 'Body',
        createdAt: DateTime.now(),
      ));
      await repo.putVolunteer(VolunteerRegistration(
        id: 'v1',
        name: 'Test',
        phone: '123',
        registeredAt: DateTime.now(),
      ));

      final announcements = await repo.loadAll();
      final volunteers = await repo.loadVolunteers();

      expect(announcements.length, 1);
      expect(volunteers.length, 1);

      await repo.deleteAnnouncement('a1');
      expect((await repo.loadVolunteers()).length, 1);
    });
  });
}
