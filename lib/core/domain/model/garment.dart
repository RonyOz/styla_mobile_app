class Garment {
  final String id;
  final String userId;
  final String imageUrl;
  String? categoryName;
  List<String>? tagNames;
  final DateTime createdAt;
  final String color;
  final String style;
  final String occasion;

  Garment({
    required this.id,
    required this.userId,
    required this.imageUrl,
    this.categoryName,
    this.tagNames,
    required this.createdAt,
    required this.color,
    required this.style,
    required this.occasion,
  });

  factory Garment.empty() {
    return Garment(
      id: '',
      userId: '',
      imageUrl: '',
      categoryName: '',
      tagNames: [],
      createdAt: DateTime.now(),
      color: '',
      style: '',
      occasion: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'color': color,
      'style': style,
      'occasion': occasion,
    };
  }

  factory Garment.fromJson(Map<String, dynamic> json) {
    return Garment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      color: json['color'] as String? ?? '',
      style: json['style'] as String? ?? '',
      occasion: json['occasion'] as String? ?? '',
    );
  }

  Garment copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? categoryName,
    List<String>? tagNames,
    DateTime? createdAt,
    String? color,
    String? style,
    String? occasion,
  }) {
    return Garment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryName: categoryName ?? this.categoryName,
      tagNames: tagNames ?? this.tagNames,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      style: style ?? this.style,
      occasion: occasion ?? this.occasion,
    );
  }

  @override
  String toString() {
    return 'Garment(id: $id, userId: $userId, categoryName: $categoryName, tagNames: $tagNames, color: $color, style: $style, occasion: $occasion)';
  }
}
