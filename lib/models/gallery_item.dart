class GalleryItem {
  final String id;
  final String imageUrl;
  final String? localPath;  // For locally stored images
  final String? title;
  final String? description;
  final String category;
  final DateTime uploadedAt;
  final bool isActive;
  final bool isLocal;  // Flag to identify if image is from local storage

  GalleryItem({
    required this.id,
    required this.imageUrl,
    this.localPath,
    this.title,
    this.description,
    this.category = 'general',
    required this.uploadedAt,
    this.isActive = true,
    this.isLocal = false,
  });

  // Get the appropriate image path (URL or local)
  String get imagePath => isLocal && localPath != null ? localPath! : imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'localPath': localPath,
      'title': title,
      'description': description,
      'category': category,
      'uploadedAt': uploadedAt.toIso8601String(),
      'isActive': isActive,
      'isLocal': isLocal,
    };
  }

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      localPath: json['localPath'],
      title: json['title'],
      description: json['description'],
      category: json['category'] ?? 'general',
      uploadedAt: DateTime.parse(json['uploadedAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      isLocal: json['isLocal'] ?? false,
    );
  }

  GalleryItem copyWith({
    String? id,
    String? imageUrl,
    String? localPath,
    String? title,
    String? description,
    String? category,
    DateTime? uploadedAt,
    bool? isActive,
    bool? isLocal,
  }) {
    return GalleryItem(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      localPath: localPath ?? this.localPath,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isActive: isActive ?? this.isActive,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}
