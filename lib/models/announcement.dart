class Announcement {
  final String id;
  final String title;
  final String body;
  final String category; // 'general', 'bhog', 'volunteer', 'emergency'
  final DateTime createdAt;
  final bool isActive;
  final bool isPinned;

  Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.category = 'general',
    required this.createdAt,
    this.isActive = true,
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'isPinned': isPinned,
    };
  }

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      category: json['category'] ?? 'general',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
      isPinned: json['isPinned'] ?? false,
    );
  }

  Announcement copyWith({
    String? id,
    String? title,
    String? body,
    String? category,
    DateTime? createdAt,
    bool? isActive,
    bool? isPinned,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  static const List<String> categories = [
    'general',
    'bhog',
    'volunteer',
    'emergency',
  ];
}

class VolunteerRegistration {
  final String id;
  final String name;
  final String phone;
  final String availability; // 'morning', 'afternoon', 'evening', 'fullDay'
  final DateTime registeredAt;

  VolunteerRegistration({
    required this.id,
    required this.name,
    required this.phone,
    this.availability = 'fullDay',
    required this.registeredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'availability': availability,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }

  factory VolunteerRegistration.fromJson(Map<String, dynamic> json) {
    return VolunteerRegistration(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      availability: json['availability'] ?? 'fullDay',
      registeredAt:
          DateTime.tryParse(json['registeredAt'] ?? '') ?? DateTime.now(),
    );
  }
}
