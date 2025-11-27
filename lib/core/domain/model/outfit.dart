class Outfit {
  final String? id;
  final String name;
  final String description;
  final String createdAt;
  final String userId;
  final String promptId;
  final String imageUrl;

  Outfit({
    this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.userId,
    required this.promptId,
    required this.imageUrl,
  });

  factory Outfit.empty() {
    return Outfit(
      id: '',
      name: '',
      description: '',
      createdAt: '',
      userId: '',
      promptId: '',
      imageUrl: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'created_at': createdAt,
      'users_user_id': userId,
      'prompts_prompt_id': promptId,
      'image_url': imageUrl,
    };
  }

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['outfit_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
      userId: json['users_user_id'] as String,
      promptId: json['prompts_prompt_id'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  Outfit copyWith({
    String? id,
    String? name,
    String? description,
    String? createdAt,
    String? userId,
    String? promptId,
    String? imageUrl,
  }) {
    return Outfit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      promptId: promptId ?? this.promptId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  String toString() {
    return 'Outfit(name: $name, description: $description, createdAt: $createdAt, userId: $userId, promptId: $promptId, imageUrl: $imageUrl)';
  }
}
