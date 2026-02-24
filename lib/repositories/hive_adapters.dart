import 'package:hive/hive.dart';
import '../models/donation.dart';
import '../models/event.dart';
import '../models/gallery_item.dart';
import '../models/admin_user.dart';
import '../models/announcement.dart';

// ── Type IDs ──────────────────────────────────────────────────────
// 0 = Donation
// 1 = Event
// 2 = GalleryItem
// 3 = AdminUser
// 4 = AdminRole
// 5 = Announcement
// 6 = VolunteerRegistration

/// Registers all Hive adapters. Call once before opening any box.
void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(DonationAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(EventAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(GalleryItemAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(AdminUserAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(AdminRoleAdapter());
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(AnnouncementAdapter());
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(VolunteerRegistrationAdapter());
  }
}

// ── Donation (typeId: 0) ──────────────────────────────────────────
class DonationAdapter extends TypeAdapter<Donation> {
  @override
  final int typeId = 0;

  @override
  Donation read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return Donation(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      phone: map['phone'],
      email: map['email'],
      status: map['status'] ?? 'completed',
      paymentMethod: map['paymentMethod'] ?? 'PhonePe',
      purpose: map['purpose'] ?? 'General',
    );
  }

  @override
  void write(BinaryWriter writer, Donation obj) {
    writer.writeMap({
      'id': obj.id,
      'name': obj.name,
      'location': obj.location,
      'amount': obj.amount,
      'date': obj.date.millisecondsSinceEpoch,
      'phone': obj.phone,
      'email': obj.email,
      'status': obj.status,
      'paymentMethod': obj.paymentMethod,
      'purpose': obj.purpose,
    });
  }
}

// ── Event (typeId: 1) ─────────────────────────────────────────────
class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 1;

  @override
  Event read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      location: map['location'],
      imageUrl: map['imageUrl'],
      isActive: map['isActive'] ?? true,
      category: map['category'] ?? 'general',
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer.writeMap({
      'id': obj.id,
      'title': obj.title,
      'description': obj.description,
      'date': obj.date.millisecondsSinceEpoch,
      'location': obj.location,
      'imageUrl': obj.imageUrl,
      'isActive': obj.isActive,
      'category': obj.category,
    });
  }
}

// ── GalleryItem (typeId: 2) ───────────────────────────────────────
class GalleryItemAdapter extends TypeAdapter<GalleryItem> {
  @override
  final int typeId = 2;

  @override
  GalleryItem read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return GalleryItem(
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      localPath: map['localPath'],
      title: map['title'],
      description: map['description'],
      category: map['category'] ?? 'general',
      uploadedAt: DateTime.fromMillisecondsSinceEpoch(map['uploadedAt'] ?? 0),
      isActive: map['isActive'] ?? true,
      isLocal: map['isLocal'] ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, GalleryItem obj) {
    writer.writeMap({
      'id': obj.id,
      'imageUrl': obj.imageUrl,
      'localPath': obj.localPath,
      'title': obj.title,
      'description': obj.description,
      'category': obj.category,
      'uploadedAt': obj.uploadedAt.millisecondsSinceEpoch,
      'isActive': obj.isActive,
      'isLocal': obj.isLocal,
    });
  }
}

// ── AdminRole (typeId: 4) ─────────────────────────────────────────
class AdminRoleAdapter extends TypeAdapter<AdminRole> {
  @override
  final int typeId = 4;

  @override
  AdminRole read(BinaryReader reader) {
    final name = reader.readString();
    return AdminRole.values.firstWhere(
      (r) => r.name == name,
      orElse: () => AdminRole.admin,
    );
  }

  @override
  void write(BinaryWriter writer, AdminRole obj) {
    writer.writeString(obj.name);
  }
}

// ── AdminUser (typeId: 3) ─────────────────────────────────────────
class AdminUserAdapter extends TypeAdapter<AdminUser> {
  @override
  final int typeId = 3;

  @override
  AdminUser read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return AdminUser(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      role: AdminRole.values.firstWhere(
        (r) => r.name == (map['role'] ?? 'admin'),
        orElse: () => AdminRole.admin,
      ),
      passwordHash: map['passwordHash'] ?? '',
      salt: map['salt'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      lastLogin: map['lastLogin'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLogin'])
          : null,
      isActive: map['isActive'] ?? true,
    );
  }

  @override
  void write(BinaryWriter writer, AdminUser obj) {
    writer.writeMap({
      'id': obj.id,
      'username': obj.username,
      'email': obj.email,
      'role': obj.role.name,
      'passwordHash': obj.passwordHash,
      'salt': obj.salt,
      'createdAt': obj.createdAt.millisecondsSinceEpoch,
      'lastLogin': obj.lastLogin?.millisecondsSinceEpoch,
      'isActive': obj.isActive,
    });
  }
}

// ── Announcement (typeId: 5) ──────────────────────────────────────
class AnnouncementAdapter extends TypeAdapter<Announcement> {
  @override
  final int typeId = 5;

  @override
  Announcement read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return Announcement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      category: map['category'] ?? 'general',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      isActive: map['isActive'] ?? true,
      isPinned: map['isPinned'] ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, Announcement obj) {
    writer.writeMap({
      'id': obj.id,
      'title': obj.title,
      'body': obj.body,
      'category': obj.category,
      'createdAt': obj.createdAt.millisecondsSinceEpoch,
      'isActive': obj.isActive,
      'isPinned': obj.isPinned,
    });
  }
}

// ── VolunteerRegistration (typeId: 6) ─────────────────────────────
class VolunteerRegistrationAdapter extends TypeAdapter<VolunteerRegistration> {
  @override
  final int typeId = 6;

  @override
  VolunteerRegistration read(BinaryReader reader) {
    final map = reader.readMap().cast<String, dynamic>();
    return VolunteerRegistration(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      availability: map['availability'] ?? 'fullDay',
      registeredAt:
          DateTime.fromMillisecondsSinceEpoch(map['registeredAt'] ?? 0),
    );
  }

  @override
  void write(BinaryWriter writer, VolunteerRegistration obj) {
    writer.writeMap({
      'id': obj.id,
      'name': obj.name,
      'phone': obj.phone,
      'availability': obj.availability,
      'registeredAt': obj.registeredAt.millisecondsSinceEpoch,
    });
  }
}
