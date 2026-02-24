class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? location;
  final String? imageUrl;
  final bool isActive;
  final String category;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.location,
    this.imageUrl,
    this.isActive = true,
    this.category = 'general',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'category': category,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      final dateString = json['date'] ?? DateTime.now().toIso8601String();
      final date = DateTime.tryParse(dateString) ?? DateTime.now();
      return Event(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        date: date,
        location: json['location'],
        imageUrl: json['imageUrl'],
        isActive: json['isActive'] ?? true,
        category: json['category'] ?? 'general',
      );
    } catch (e) {
      // If parsing fails, return a default event or handle as needed
      return Event(
        id: '',
        title: 'Invalid Event',
        description: 'Event data corrupted',
        date: DateTime.now(),
        isActive: false,
      );
    }
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    String? imageUrl,
    bool? isActive,
    String? category,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      category: category ?? this.category,
    );
  }
}
