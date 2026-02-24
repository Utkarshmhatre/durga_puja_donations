import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';

abstract class EventRepository {
  Future<List<Event>> loadAll();
  Future<void> saveAll(List<Event> events);
}

class SharedPrefsEventRepository implements EventRepository {
  static const String _eventsKey = 'events';

  @override
  Future<List<Event>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_eventsKey);
    if (eventsJson == null || eventsJson.isEmpty) {
      return [];
    }

    final List<dynamic> eventsList = jsonDecode(eventsJson);
    return eventsList.map((e) => Event.fromJson(e)).toList();
  }

  @override
  Future<void> saveAll(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _eventsKey,
      jsonEncode(events.map((e) => e.toJson()).toList()),
    );
  }
}
