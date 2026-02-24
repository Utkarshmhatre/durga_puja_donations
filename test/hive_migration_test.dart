import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:durga_puja_donations/repositories/hive_adapters.dart';
import 'package:durga_puja_donations/services/hive_migration_service.dart';
import 'package:durga_puja_donations/models/donation.dart';
import 'package:durga_puja_donations/models/event.dart';
import 'package:durga_puja_donations/models/gallery_item.dart';
import 'package:durga_puja_donations/models/announcement.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_migration_test_');
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
    // Clear all Hive boxes and unset migration flag
    for (final boxName in [
      'donations',
      'events',
      'gallery',
      'admin_auth',
      'announcements',
      'volunteers'
    ]) {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).clear();
        await Hive.box(boxName).close();
      }
      // Delete box file if exists
      final boxFile = File('${tempDir.path}/$boxName.hive');
      if (boxFile.existsSync()) boxFile.deleteSync();
    }
  });

  group('HiveMigrationService', () {
    test('migrates donations from SharedPreferences to Hive', () async {
      final donations = [
        Donation(
            id: 'd1',
            name: 'Bikash',
            location: 'Kolkata',
            amount: 500,
            date: DateTime(2026, 9, 20)),
        Donation(
            id: 'd2',
            name: 'Anjali',
            location: 'Mumbai',
            amount: 1000,
            date: DateTime(2026, 9, 21)),
      ];

      SharedPreferences.setMockInitialValues({
        'donations': jsonEncode(donations.map((d) => d.toJson()).toList()),
      });

      await HiveMigrationService.migrate();

      final box = await Hive.openBox<Donation>('donations');
      expect(box.length, 2);
      expect(box.get('d1')!.name, 'Bikash');
      expect(box.get('d2')!.amount, 1000);
      await box.close();
    });

    test('migrates events from SharedPreferences to Hive', () async {
      final events = [
        Event(
            id: 'e1',
            title: 'Mahalaya',
            description: 'Dawn',
            date: DateTime(2026, 9, 20),
            category: 'religious'),
      ];

      SharedPreferences.setMockInitialValues({
        'events': jsonEncode(events.map((e) => e.toJson()).toList()),
      });

      await HiveMigrationService.migrate();

      final box = await Hive.openBox<Event>('events');
      expect(box.length, 1);
      expect(box.get('e1')!.title, 'Mahalaya');
      await box.close();
    });

    test('migrates gallery items from SharedPreferences to Hive', () async {
      final items = [
        GalleryItem(
            id: 'g1',
            imageUrl: 'https://example.com/1.jpg',
            title: 'Idol',
            uploadedAt: DateTime(2026, 9, 20)),
      ];

      SharedPreferences.setMockInitialValues({
        'gallery': jsonEncode(items.map((g) => g.toJson()).toList()),
      });

      await HiveMigrationService.migrate();

      // Gallery is stored as regular box during migration
      final box = await Hive.openBox<GalleryItem>('gallery');
      expect(box.length, 1);
      expect(box.get('g1')!.title, 'Idol');
      await box.close();
    });

    test('migrates announcements from SharedPreferences to Hive', () async {
      final announcements = [
        Announcement(
            id: 'a1',
            title: 'Welcome',
            body: 'Hello',
            createdAt: DateTime(2026, 9, 20)),
      ];

      SharedPreferences.setMockInitialValues({
        'announcements':
            jsonEncode(announcements.map((a) => a.toJson()).toList()),
      });

      await HiveMigrationService.migrate();

      final box = await Hive.openBox<Announcement>('announcements');
      expect(box.length, 1);
      expect(box.get('a1')!.title, 'Welcome');
      await box.close();
    });

    test('sets hive_migrated flag after migration', () async {
      SharedPreferences.setMockInitialValues({});
      await HiveMigrationService.migrate();

      expect(await HiveMigrationService.isMigrated(), true);
    });

    test('no-ops when migration flag is already set', () async {
      SharedPreferences.setMockInitialValues({
        'hive_migrated': true,
        'donations': jsonEncode([
          Donation(
                  id: 'should_not_migrate',
                  name: 'X',
                  location: 'Y',
                  amount: 1,
                  date: DateTime.now())
              .toJson(),
        ]),
      });

      await HiveMigrationService.migrate();

      final box = await Hive.openBox<Donation>('donations');
      expect(box.isEmpty, true);
      await box.close();
    });

    test('handles empty SharedPreferences gracefully', () async {
      SharedPreferences.setMockInitialValues({});
      await HiveMigrationService.migrate();

      final box = await Hive.openBox<Donation>('donations');
      expect(box.isEmpty, true);
      await box.close();
    });

    test('cleans up old SharedPreferences keys after migration', () async {
      SharedPreferences.setMockInitialValues({
        'donations': '[]',
        'events': '[]',
        'gallery': '[]',
        'admin_users': '[]',
        'announcements': '[]',
        'volunteers': '[]',
        'admin_seeded': true,
      });

      await HiveMigrationService.migrate();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('donations'), isNull);
      expect(prefs.getString('events'), isNull);
      expect(prefs.getString('gallery'), isNull);
      expect(prefs.getString('admin_users'), isNull);
      expect(prefs.getString('announcements'), isNull);
      expect(prefs.getString('volunteers'), isNull);
      expect(prefs.getBool('admin_seeded'), isNull);
    });
  });
}
