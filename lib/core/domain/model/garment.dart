class Garment {
  final String id;
  final String userId;
  final String imageUrl;
  final String categoryName;
  final List<String> tagNames;
  final DateTime createdAt;

  Garment({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.categoryName,
    required this.tagNames,
    required this.createdAt,
  });

  factory Garment.empty() {
    return Garment(
      id: '',
      userId: '',
      imageUrl: '',
      categoryName: '',
      tagNames: [],
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'category_name': categoryName,
      'tag_names': tagNames,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Garment.fromJson(Map<String, dynamic> json) {
    return Garment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      categoryName: json['category_name'] as String,
      tagNames: (json['tag_names'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Garment copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? categoryName,
    List<String>? tagNames,
    DateTime? createdAt,
  }) {
    return Garment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryName: categoryName ?? this.categoryName,
      tagNames: tagNames ?? this.tagNames,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Garment(id: $id, userId: $userId, categoryName: $categoryName, tagNames: $tagNames)';
  }
}
