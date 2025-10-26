class Garment {
  final String id;
  final String userId;
  final String imageUrl;
  final String category;
  final List<String> tags;
  final DateTime createdAt;

  Garment({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.category,
    required this.tags,
    required this.createdAt,
  });

  factory Garment.empty() {
    return Garment(
      id: '',
      userId: '',
      imageUrl: '',
      category: '',
      tags: [],
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'category': category,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Garment.fromJson(Map<String, dynamic> json) {
    return Garment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      category: json['category'] as String,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Garment copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return Garment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Garment(id: $id, userId: $userId, category: $category, tags: $tags)';
  }
}
