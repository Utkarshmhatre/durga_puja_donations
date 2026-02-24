import 'package:hive/hive.dart';
import '../models/announcement.dart';
import 'announcement_repository.dart';

class HiveAnnouncementRepository implements AnnouncementRepository {
  static const String announcementsBoxName = 'announcements';
  static const String volunteersBoxName = 'volunteers';

  Box<Announcement>? _announcementsBox;
  Box<VolunteerRegistration>? _volunteersBox;

  Future<Box<Announcement>> get _openAnnouncementsBox async {
    _announcementsBox ??=
        await Hive.openBox<Announcement>(announcementsBoxName);
    return _announcementsBox!;
  }

  Future<Box<VolunteerRegistration>> get _openVolunteersBox async {
    _volunteersBox ??=
        await Hive.openBox<VolunteerRegistration>(volunteersBoxName);
    return _volunteersBox!;
  }

  @override
  Future<List<Announcement>> loadAll() async {
    final box = await _openAnnouncementsBox;
    return box.values.toList();
  }

  @override
  Future<void> saveAll(List<Announcement> announcements) async {
    final box = await _openAnnouncementsBox;
    await box.clear();
    for (final a in announcements) {
      await box.put(a.id, a);
    }
  }

  @override
  Future<List<VolunteerRegistration>> loadVolunteers() async {
    final box = await _openVolunteersBox;
    return box.values.toList();
  }

  @override
  Future<void> saveVolunteers(List<VolunteerRegistration> volunteers) async {
    final box = await _openVolunteersBox;
    await box.clear();
    for (final v in volunteers) {
      await box.put(v.id, v);
    }
  }

  Future<void> putAnnouncement(Announcement announcement) async {
    final box = await _openAnnouncementsBox;
    await box.put(announcement.id, announcement);
  }

  Future<void> deleteAnnouncement(String id) async {
    final box = await _openAnnouncementsBox;
    await box.delete(id);
  }

  Future<void> putVolunteer(VolunteerRegistration volunteer) async {
    final box = await _openVolunteersBox;
    await box.put(volunteer.id, volunteer);
  }

  Future<void> deleteVolunteer(String id) async {
    final box = await _openVolunteersBox;
    await box.delete(id);
  }
}
