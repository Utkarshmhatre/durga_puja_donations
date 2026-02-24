import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:durga_puja_donations/repositories/hive_adapters.dart';
import 'package:durga_puja_donations/repositories/hive_gallery_repository.dart';
import 'package:durga_puja_donations/models/gallery_item.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_gallery_test_');
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
    if (Hive.isBoxOpen(HiveGalleryRepository.boxName)) {
      final box = Hive.lazyBox<GalleryItem>(HiveGalleryRepository.boxName);
      await box.clear();
    }
  });

  group('HiveGalleryRepository (LazyBox)', () {
    test('loadAll returns empty list when no data', () async {
      final repo = HiveGalleryRepository();
      final result = await repo.loadAll();
      expect(result, isEmpty);
    });

    test('saveAll and loadAll roundtrip', () async {
      final repo = HiveGalleryRepository();
      final items = [
        GalleryItem(
          id: 'g1',
          imageUrl: 'https://example.com/1.jpg',
          title: 'Idol 2026',
          category: 'idol',
          uploadedAt: DateTime(2026, 9, 20),
        ),
        GalleryItem(
          id: 'g2',
          imageUrl: 'https://example.com/2.jpg',
          title: 'Celebration',
          category: 'celebration',
          uploadedAt: DateTime(2026, 9, 25),
        ),
      ];

      await repo.saveAll(items);
      final loaded = await repo.loadAll();

      expect(loaded.length, 2);
      expect(loaded.any((g) => g.id == 'g1'), true);
      expect(loaded.any((g) => g.id == 'g2'), true);
    });

    test('put and get individual item', () async {
      final repo = HiveGalleryRepository();
      final item = GalleryItem(
        id: 'g3',
        imageUrl: 'https://example.com/3.jpg',
        localPath: '/path/to/local.jpg',
        title: 'Local Photo',
        category: 'general',
        uploadedAt: DateTime(2026, 9, 22),
        isLocal: true,
      );

      await repo.put(item);
      final result = await repo.get('g3');

      expect(result, isNotNull);
      expect(result!.title, 'Local Photo');
      expect(result.isLocal, true);
      expect(result.localPath, '/path/to/local.jpg');
    });

    test('delete removes item', () async {
      final repo = HiveGalleryRepository();
      await repo.put(GalleryItem(
        id: 'del',
        imageUrl: 'https://example.com/del.jpg',
        uploadedAt: DateTime.now(),
      ));

      await repo.delete('del');
      final result = await repo.get('del');
      expect(result, isNull);
    });

    test('loadPage returns paginated subset', () async {
      final repo = HiveGalleryRepository();
      final items = List.generate(
        10,
        (i) => GalleryItem(
          id: 'pg$i',
          imageUrl: 'https://example.com/$i.jpg',
          title: 'Item $i',
          uploadedAt: DateTime(2026, 9, 20),
        ),
      );
      await repo.saveAll(items);

      final page1 = await repo.loadPage(0, 3);
      expect(page1.length, 3);

      final page2 = await repo.loadPage(3, 3);
      expect(page2.length, 3);

      final lastPage = await repo.loadPage(9, 5);
      expect(lastPage.length, 1);
    });
  });
}
