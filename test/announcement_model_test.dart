import 'package:flutter_test/flutter_test.dart';
import 'package:durga_puja_donations/models/announcement.dart';

void main() {
  group('Announcement', () {
    test('creates with required fields', () {
      final now = DateTime(2026, 9, 25, 10, 0);
      final a = Announcement(
        id: 'a1',
        title: 'Test Announcement',
        body: 'Test body text',
        createdAt: now,
      );

      expect(a.id, 'a1');
      expect(a.title, 'Test Announcement');
      expect(a.body, 'Test body text');
      expect(a.category, 'general');
      expect(a.isActive, true);
      expect(a.isPinned, false);
      expect(a.createdAt, now);
    });

    test('creates with all fields', () {
      final a = Announcement(
        id: 'a2',
        title: 'Emergency',
        body: 'Urgent notice',
        category: 'emergency',
        createdAt: DateTime(2026, 9, 26),
        isActive: false,
        isPinned: true,
      );

      expect(a.category, 'emergency');
      expect(a.isActive, false);
      expect(a.isPinned, true);
    });

    test('toJson serializes all fields', () {
      final now = DateTime(2026, 9, 25, 10, 0);
      final a = Announcement(
        id: 'a1',
        title: 'Title',
        body: 'Body',
        category: 'bhog',
        createdAt: now,
        isPinned: true,
      );

      final json = a.toJson();
      expect(json['id'], 'a1');
      expect(json['title'], 'Title');
      expect(json['body'], 'Body');
      expect(json['category'], 'bhog');
      expect(json['createdAt'], now.toIso8601String());
      expect(json['isActive'], true);
      expect(json['isPinned'], true);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'a3',
        'title': 'Bhog Schedule',
        'body': 'Noon bhog at 12 PM',
        'category': 'bhog',
        'createdAt': '2026-09-25T12:00:00.000',
        'isActive': true,
        'isPinned': false,
      };

      final a = Announcement.fromJson(json);
      expect(a.id, 'a3');
      expect(a.title, 'Bhog Schedule');
      expect(a.body, 'Noon bhog at 12 PM');
      expect(a.category, 'bhog');
      expect(a.isActive, true);
      expect(a.isPinned, false);
    });

    test('fromJson handles missing fields with defaults', () {
      final a = Announcement.fromJson({});
      expect(a.id, '');
      expect(a.title, '');
      expect(a.body, '');
      expect(a.category, 'general');
      expect(a.isActive, true);
      expect(a.isPinned, false);
    });

    test('roundtrip toJson/fromJson preserves data', () {
      final original = Announcement(
        id: 'roundtrip1',
        title: 'Roundtrip Test',
        body: 'Testing serialization roundtrip',
        category: 'volunteer',
        createdAt: DateTime(2026, 9, 28, 14, 30),
        isActive: false,
        isPinned: true,
      );

      final restored = Announcement.fromJson(original.toJson());
      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.body, original.body);
      expect(restored.category, original.category);
      expect(restored.isActive, original.isActive);
      expect(restored.isPinned, original.isPinned);
    });

    test('copyWith creates modified copy', () {
      final a = Announcement(
        id: 'orig',
        title: 'Original',
        body: 'Original body',
        createdAt: DateTime(2026, 9, 25),
      );

      final modified = a.copyWith(title: 'Modified', isPinned: true);
      expect(modified.id, 'orig');
      expect(modified.title, 'Modified');
      expect(modified.body, 'Original body');
      expect(modified.isPinned, true);
    });

    test('categories contains expected values', () {
      expect(Announcement.categories, ['general', 'bhog', 'volunteer', 'emergency']);
    });
  });

  group('VolunteerRegistration', () {
    test('creates with required fields', () {
      final now = DateTime(2026, 9, 25);
      final v = VolunteerRegistration(
        id: 'v1',
        name: 'Rina Das',
        phone: '9876543210',
        registeredAt: now,
      );

      expect(v.id, 'v1');
      expect(v.name, 'Rina Das');
      expect(v.phone, '9876543210');
      expect(v.availability, 'fullDay');
      expect(v.registeredAt, now);
    });

    test('creates with custom availability', () {
      final v = VolunteerRegistration(
        id: 'v2',
        name: 'Amit Ghosh',
        phone: '1234567890',
        availability: 'morning',
        registeredAt: DateTime(2026, 9, 26),
      );

      expect(v.availability, 'morning');
    });

    test('toJson serializes correctly', () {
      final v = VolunteerRegistration(
        id: 'v1',
        name: 'Test Volunteer',
        phone: '5555555555',
        availability: 'evening',
        registeredAt: DateTime(2026, 9, 25, 10, 0),
      );

      final json = v.toJson();
      expect(json['id'], 'v1');
      expect(json['name'], 'Test Volunteer');
      expect(json['phone'], '5555555555');
      expect(json['availability'], 'evening');
      expect(json['registeredAt'], '2026-09-25T10:00:00.000');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'v3',
        'name': 'Priya Sen',
        'phone': '9999999999',
        'availability': 'afternoon',
        'registeredAt': '2026-09-27T09:00:00.000',
      };

      final v = VolunteerRegistration.fromJson(json);
      expect(v.id, 'v3');
      expect(v.name, 'Priya Sen');
      expect(v.phone, '9999999999');
      expect(v.availability, 'afternoon');
    });

    test('fromJson handles missing fields', () {
      final v = VolunteerRegistration.fromJson({});
      expect(v.id, '');
      expect(v.name, '');
      expect(v.phone, '');
      expect(v.availability, 'fullDay');
    });

    test('roundtrip toJson/fromJson preserves data', () {
      final original = VolunteerRegistration(
        id: 'rt1',
        name: 'Roundtrip Vol',
        phone: '1112223333',
        availability: 'morning',
        registeredAt: DateTime(2026, 9, 28, 8, 0),
      );

      final restored = VolunteerRegistration.fromJson(original.toJson());
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.phone, original.phone);
      expect(restored.availability, original.availability);
    });
  });
}
