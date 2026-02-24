import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:durga_puja_donations/repositories/hive_adapters.dart';
import 'package:durga_puja_donations/repositories/hive_event_repository.dart';
import 'package:durga_puja_donations/models/event.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_event_test_');
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
    if (Hive.isBoxOpen(HiveEventRepository.boxName)) {
      await Hive.box<Event>(HiveEventRepository.boxName).clear();
    }
  });

  group('HiveEventRepository', () {
    test('loadAll returns empty list when no data', () async {
      final repo = HiveEventRepository();
      final result = await repo.loadAll();
      expect(result, isEmpty);
    });

    test('saveAll and loadAll roundtrip', () async {
      final repo = HiveEventRepository();
      final events = [
        Event(
          id: 'e1',
          title: 'Mahalaya',
          description: 'Dawn of Puja',
          date: DateTime(2026, 9, 20),
          location: 'Pandal',
          category: 'religious',
        ),
        Event(
          id: 'e2',
          title: 'Cultural Night',
          description: 'Dance and music',
          date: DateTime(2026, 9, 25),
          category: 'cultural',
        ),
      ];

      await repo.saveAll(events);
      final loaded = await repo.loadAll();

      expect(loaded.length, 2);
      expect(loaded[0].title, 'Mahalaya');
      expect(loaded[0].category, 'religious');
      expect(loaded[1].title, 'Cultural Night');
    });

    test('put and get individual event', () async {
      final repo = HiveEventRepository();
      final event = Event(
        id: 'e3',
        title: 'Dashami',
        description: 'Visarjan ceremony',
        date: DateTime(2026, 9, 30),
        location: 'River Ghat',
      );

      await repo.put(event);
      final result = await repo.get('e3');

      expect(result, isNotNull);
      expect(result!.title, 'Dashami');
      expect(result.location, 'River Ghat');
    });

    test('delete removes event', () async {
      final repo = HiveEventRepository();
      await repo.put(Event(
        id: 'del',
        title: 'Remove me',
        description: 'To delete',
        date: DateTime.now(),
      ));

      await repo.delete('del');
      final result = await repo.get('del');
      expect(result, isNull);
    });

    test('preserves nullable fields', () async {
      final repo = HiveEventRepository();
      final event = Event(
        id: 'n1',
        title: 'Test',
        description: 'With image',
        date: DateTime(2026, 9, 20),
        imageUrl: 'https://example.com/img.jpg',
        location: null,
      );

      await repo.put(event);
      final result = await repo.get('n1');

      expect(result!.imageUrl, 'https://example.com/img.jpg');
      expect(result.location, isNull);
    });
  });
}
