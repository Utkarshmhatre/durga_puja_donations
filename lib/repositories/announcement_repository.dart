import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/announcement.dart';

abstract class AnnouncementRepository {
  Future<List<Announcement>> loadAll();
  Future<void> saveAll(List<Announcement> announcements);
  Future<List<VolunteerRegistration>> loadVolunteers();
  Future<void> saveVolunteers(List<VolunteerRegistration> volunteers);
}

class SharedPrefsAnnouncementRepository implements AnnouncementRepository {
  static const String _announcementsKey = 'announcements';
  static const String _volunteersKey = 'volunteers';

  @override
  Future<List<Announcement>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_announcementsKey);
    if (data == null) return [];
    final List<dynamic> jsonList = json.decode(data);
    return jsonList
        .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAll(List<Announcement> announcements) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(announcements.map((a) => a.toJson()).toList());
    await prefs.setString(_announcementsKey, data);
  }

  @override
  Future<List<VolunteerRegistration>> loadVolunteers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_volunteersKey);
    if (data == null) return [];
    final List<dynamic> jsonList = json.decode(data);
    return jsonList
        .map((e) => VolunteerRegistration.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveVolunteers(List<VolunteerRegistration> volunteers) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(volunteers.map((v) => v.toJson()).toList());
    await prefs.setString(_volunteersKey, data);
  }
}
