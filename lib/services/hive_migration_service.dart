import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_user.dart';
import '../models/announcement.dart';
import '../models/donation.dart';
import '../models/event.dart';
import '../models/gallery_item.dart';

/// One-time migration from SharedPreferences JSON storage to Hive boxes.
///
/// Reads existing data from SharedPreferences keys, writes to the
/// corresponding Hive boxes, sets a migration flag, then deletes the
/// old SharedPreferences keys.
class HiveMigrationService {
  static const String _migrationFlagKey = 'hive_migrated';

  /// Returns true if migration has already been completed.
  static Future<bool> isMigrated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_migrationFlagKey) ?? false;
  }

  /// Run the full migration. Safe to call multiple times — will no-op
  /// if the migration flag is already set.
  static Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_migrationFlagKey) == true) return;

    try {
      await _migrateDonations(prefs);
      await _migrateEvents(prefs);
      await _migrateGallery(prefs);
      await _migrateAdminUsers(prefs);
      await _migrateAnnouncements(prefs);
      await _migrateVolunteers(prefs);

      // Mark migration complete
      await prefs.setBool(_migrationFlagKey, true);

      // Clean up old keys
      await _cleanupOldKeys(prefs);

      debugPrint('[HiveMigration] Migration completed successfully');
    } catch (e, stack) {
      debugPrint('[HiveMigration] Migration failed: $e\n$stack');
      // Don't set the flag — migration will be retried on next launch
    }
  }

  static Future<void> _migrateDonations(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('donations');
    if (jsonStr == null || jsonStr.isEmpty) return;

    final List<dynamic> list = json.decode(jsonStr);
    final donations = list.map((d) => Donation.fromJson(d)).toList();

    final box = await Hive.openBox<Donation>('donations');
    if (box.isEmpty) {
      for (final d in donations) {
        await box.put(d.id, d);
      }
      debugPrint('[HiveMigration] Migrated ${donations.length} donations');
    }
  }

  static Future<void> _migrateEvents(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('events');
    if (jsonStr == null || jsonStr.isEmpty) return;

    final List<dynamic> list = json.decode(jsonStr);
    final events = list.map((e) => Event.fromJson(e)).toList();

    final box = await Hive.openBox<Event>('events');
    if (box.isEmpty) {
      for (final e in events) {
        await box.put(e.id, e);
      }
      debugPrint('[HiveMigration] Migrated ${events.length} events');
    }
  }

  static Future<void> _migrateGallery(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('gallery');
    if (jsonStr == null || jsonStr.isEmpty) return;

    final List<dynamic> list = json.decode(jsonStr);
    final items = list.map((g) => GalleryItem.fromJson(g)).toList();

    // Gallery uses LazyBox in production, but for migration we use a regular box
    final box = await Hive.openBox<GalleryItem>('gallery');
    if (box.isEmpty) {
      for (final item in items) {
        await box.put(item.id, item);
      }
      debugPrint('[HiveMigration] Migrated ${items.length} gallery items');
    }
    await box.close();
  }

  static Future<void> _migrateAdminUsers(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('admin_users');
    if (jsonStr == null || jsonStr.isEmpty) return;

    final List<dynamic> list = json.decode(jsonStr);
    final users = list.map((u) => AdminUser.fromJson(u)).toList();

    final box = await Hive.openBox<AdminUser>('admin_auth');
    if (box.isEmpty) {
      for (final user in users) {
        await box.put(user.id, user);
      }
      debugPrint('[HiveMigration] Migrated ${users.length} admin users');
    }
  }

  static Future<void> _migrateAnnouncements(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('announcements');
    if (jsonStr == null || jsonStr.isEmpty) return;

    final List<dynamic> list = json.decode(jsonStr);
    final announcements = list
        .map((a) => Announcement.fromJson(a as Map<String, dynamic>))
        .toList();

    final box = await Hive.openBox<Announcement>('announcements');
    if (box.isEmpty) {
      for (final a in announcements) {
        await box.put(a.id, a);
      }
      debugPrint(
          '[HiveMigration] Migrated ${announcements.length} announcements');
    }
  }

  static Future<void> _migrateVolunteers(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('volunteers');
    if (jsonStr == null || jsonStr.isEmpty) return;

    final List<dynamic> list = json.decode(jsonStr);
    final volunteers = list
        .map((v) => VolunteerRegistration.fromJson(v as Map<String, dynamic>))
        .toList();

    final box = await Hive.openBox<VolunteerRegistration>('volunteers');
    if (box.isEmpty) {
      for (final v in volunteers) {
        await box.put(v.id, v);
      }
      debugPrint('[HiveMigration] Migrated ${volunteers.length} volunteers');
    }
  }

  /// Remove the old SharedPreferences data keys after successful migration.
  static Future<void> _cleanupOldKeys(SharedPreferences prefs) async {
    const keysToRemove = [
      'donations',
      'events',
      'gallery',
      'admin_users',
      'announcements',
      'volunteers',
      'admin_seeded',
    ];
    for (final key in keysToRemove) {
      await prefs.remove(key);
    }
    debugPrint('[HiveMigration] Cleaned up old SharedPreferences keys');
  }
}
