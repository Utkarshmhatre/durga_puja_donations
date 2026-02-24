class UserFeedback {
  final String id;
  final String name;
  final String email;
  final int rating;
  final String message;
  final String category;
  final DateTime createdAt;

  UserFeedback({
    required this.id,
    required this.name,
    required this.email,
    required this.rating,
    required this.message,
    this.category = 'general',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rating': rating,
      'message': message,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserFeedback.fromJson(Map<String, dynamic> json) {
    return UserFeedback(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      rating: json['rating'] ?? 3,
      message: json['message'] ?? '',
      category: json['category'] ?? 'general',
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  UserFeedback copyWith({
    String? id,
    String? name,
    String? email,
    int? rating,
    String? message,
    String? category,
    DateTime? createdAt,
  }) {
    return UserFeedback(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      message: message ?? this.message,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static const List<String> categories = [
    'general',
    'suggestion',
    'bug',
    'praise',
  ];
}
