import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gallery_item.dart';

abstract class GalleryRepository {
  Future<List<GalleryItem>> loadAll();
  Future<void> saveAll(List<GalleryItem> items);
}

class SharedPrefsGalleryRepository implements GalleryRepository {
  static const String _galleryKey = 'gallery';

  @override
  Future<List<GalleryItem>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final galleryJson = prefs.getString(_galleryKey);
    if (galleryJson == null || galleryJson.isEmpty) {
      return [];
    }

    final List<dynamic> galleryList = jsonDecode(galleryJson);
    return galleryList.map((g) => GalleryItem.fromJson(g)).toList();
  }

  @override
  Future<void> saveAll(List<GalleryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _galleryKey,
      jsonEncode(items.map((g) => g.toJson()).toList()),
    );
  }
}
