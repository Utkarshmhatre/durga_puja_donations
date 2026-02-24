import 'package:hive/hive.dart';
import '../models/gallery_item.dart';
import 'gallery_repository.dart';

class HiveGalleryRepository implements GalleryRepository {
  static const String boxName = 'gallery';

  LazyBox<GalleryItem>? _lazyBox;

  Future<LazyBox<GalleryItem>> get _openBox async {
    _lazyBox ??= await Hive.openLazyBox<GalleryItem>(boxName);
    return _lazyBox!;
  }

  @override
  Future<List<GalleryItem>> loadAll() async {
    final box = await _openBox;
    final items = <GalleryItem>[];
    for (final key in box.keys) {
      final item = await box.get(key);
      if (item != null) items.add(item);
    }
    return items;
  }

  @override
  Future<void> saveAll(List<GalleryItem> items) async {
    final box = await _openBox;
    await box.clear();
    for (final item in items) {
      await box.put(item.id, item);
    }
  }

  Future<void> put(GalleryItem item) async {
    final box = await _openBox;
    await box.put(item.id, item);
  }

  Future<void> delete(String id) async {
    final box = await _openBox;
    await box.delete(id);
  }

  Future<GalleryItem?> get(String id) async {
    final box = await _openBox;
    return box.get(id);
  }

  /// Load a paginated subset of gallery items.
  Future<List<GalleryItem>> loadPage(int offset, int limit) async {
    final box = await _openBox;
    final keys = box.keys.toList();
    final pageKeys = keys.skip(offset).take(limit);
    final items = <GalleryItem>[];
    for (final key in pageKeys) {
      final item = await box.get(key);
      if (item != null) items.add(item);
    }
    return items;
  }
}
