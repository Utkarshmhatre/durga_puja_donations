import 'package:hive/hive.dart';
import '../models/event.dart';
import 'event_repository.dart';

class HiveEventRepository implements EventRepository {
  static const String boxName = 'events';

  Box<Event>? _box;

  Future<Box<Event>> get _openBox async {
    _box ??= await Hive.openBox<Event>(boxName);
    return _box!;
  }

  @override
  Future<List<Event>> loadAll() async {
    final box = await _openBox;
    return box.values.toList();
  }

  @override
  Future<void> saveAll(List<Event> events) async {
    final box = await _openBox;
    await box.clear();
    final map = {for (var e in events) e.id: e};
    await box.putAll(map);
  }

  Future<void> put(Event event) async {
    final box = await _openBox;
    await box.put(event.id, event);
  }

  Future<void> delete(String id) async {
    final box = await _openBox;
    await box.delete(id);
  }

  Future<Event?> get(String id) async {
    final box = await _openBox;
    return box.get(id);
  }
}
