import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:durga_puja_donations/repositories/hive_adapters.dart';
import 'package:durga_puja_donations/models/donation.dart';
import 'package:durga_puja_donations/models/event.dart';
import 'package:durga_puja_donations/models/gallery_item.dart';
import 'package:durga_puja_donations/models/admin_user.dart';
import 'package:durga_puja_donations/models/announcement.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_adapter_test_');
    Hive.init(tempDir.path);
    registerHiveAdapters();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('registerHiveAdapters', () {
    test('all 7 adapters are registered', () {
      expect(Hive.isAdapterRegistered(0), true); // Donation
      expect(Hive.isAdapterRegistered(1), true); // Event
      expect(Hive.isAdapterRegistered(2), true); // GalleryItem
      expect(Hive.isAdapterRegistered(3), true); // AdminUser
      expect(Hive.isAdapterRegistered(4), true); // AdminRole
      expect(Hive.isAdapterRegistered(5), true); // Announcement
      expect(Hive.isAdapterRegistered(6), true); // VolunteerRegistration
    });

    test('calling registerHiveAdapters twice does not throw', () {
      expect(() => registerHiveAdapters(), returnsNormally);
    });
  });

  group('DonationAdapter roundtrip', () {
    test('write/read preserves all fields', () async {
      final box = await Hive.openBox<Donation>('adapter_test_donations');
      final original = Donation(
        id: 'rt1',
        name: 'Test User',
        location: 'Test City',
        amount: 2500.50,
        date: DateTime(2026, 9, 25, 14, 30),
        phone: '9876543210',
        email: 'test@test.com',
        status: 'confirmed',
        paymentMethod: 'UPI',
        purpose: 'Bhog (Food)',
      );

      await box.put('rt1', original);
      final restored = box.get('rt1')!;

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.location, original.location);
      expect(restored.amount, original.amount);
      expect(restored.date.year, original.date.year);
      expect(restored.date.month, original.date.month);
      expect(restored.date.day, original.date.day);
      expect(restored.phone, original.phone);
      expect(restored.email, original.email);
      expect(restored.status, original.status);
      expect(restored.paymentMethod, original.paymentMethod);
      expect(restored.purpose, original.purpose);
      await box.close();
    });
  });

  group('EventAdapter roundtrip', () {
    test('write/read preserves all fields', () async {
      final box = await Hive.openBox<Event>('adapter_test_events');
      final original = Event(
        id: 'evt1',
        title: 'Saptami Puja',
        description: 'First big day',
        date: DateTime(2026, 9, 27),
        location: 'Main Pandal',
        imageUrl: 'https://example.com/saptami.jpg',
        isActive: true,
        category: 'religious',
      );

      await box.put('evt1', original);
      final restored = box.get('evt1')!;

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.location, original.location);
      expect(restored.imageUrl, original.imageUrl);
      expect(restored.isActive, original.isActive);
      expect(restored.category, original.category);
      await box.close();
    });
  });

  group('GalleryItemAdapter roundtrip', () {
    test('write/read preserves all fields', () async {
      final box = await Hive.openBox<GalleryItem>('adapter_test_gallery');
      final original = GalleryItem(
        id: 'gal1',
        imageUrl: 'https://example.com/idol.jpg',
        localPath: '/data/photos/idol.jpg',
        title: 'Main Idol',
        description: 'Artisan clay idol',
        category: 'idol',
        uploadedAt: DateTime(2026, 9, 20),
        isActive: true,
        isLocal: true,
      );

      await box.put('gal1', original);
      final restored = box.get('gal1')!;

      expect(restored.id, original.id);
      expect(restored.imageUrl, original.imageUrl);
      expect(restored.localPath, original.localPath);
      expect(restored.title, original.title);
      expect(restored.description, original.description);
      expect(restored.category, original.category);
      expect(restored.isActive, original.isActive);
      expect(restored.isLocal, original.isLocal);
      await box.close();
    });
  });

  group('AdminUserAdapter roundtrip', () {
    test('write/read preserves all fields including role', () async {
      final box = await Hive.openBox<AdminUser>('adapter_test_admin');
      final original = AdminUser(
        id: 'adm1',
        username: 'superadmin',
        email: 'admin@puja.org',
        role: AdminRole.superAdmin,
        passwordHash: 'abc123hash',
        salt: 'somesalt',
        createdAt: DateTime(2024, 1, 1),
        lastLogin: DateTime(2026, 9, 20),
        isActive: true,
      );

      await box.put('adm1', original);
      final restored = box.get('adm1')!;

      expect(restored.id, original.id);
      expect(restored.username, original.username);
      expect(restored.email, original.email);
      expect(restored.role, AdminRole.superAdmin);
      expect(restored.passwordHash, original.passwordHash);
      expect(restored.salt, original.salt);
      expect(restored.isActive, original.isActive);
      expect(restored.lastLogin, isNotNull);
      await box.close();
    });
  });

  group('AnnouncementAdapter roundtrip', () {
    test('write/read preserves all fields', () async {
      final box = await Hive.openBox<Announcement>('adapter_test_announce');
      final original = Announcement(
        id: 'ann1',
        title: 'Emergency Notice',
        body: 'Please evacuate gate 3',
        category: 'emergency',
        createdAt: DateTime(2026, 9, 28),
        isActive: true,
        isPinned: true,
      );

      await box.put('ann1', original);
      final restored = box.get('ann1')!;

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.body, original.body);
      expect(restored.category, original.category);
      expect(restored.isActive, original.isActive);
      expect(restored.isPinned, original.isPinned);
      await box.close();
    });
  });

  group('VolunteerRegistrationAdapter roundtrip', () {
    test('write/read preserves all fields', () async {
      final box =
          await Hive.openBox<VolunteerRegistration>('adapter_test_volunteer');
      final original = VolunteerRegistration(
        id: 'vol1',
        name: 'Rohit Sharma',
        phone: '9876543210',
        availability: 'evening',
        registeredAt: DateTime(2026, 9, 18),
      );

      await box.put('vol1', original);
      final restored = box.get('vol1')!;

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.phone, original.phone);
      expect(restored.availability, original.availability);
      await box.close();
    });
  });
}
