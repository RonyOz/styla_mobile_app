class Post {
  final String postId;
  final String? image;
  final String? content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String authorUserId;
  final int likesAmount;

  // Información del autor (join con profiles)
  final String? authorNickname;
  final String? authorPhoto;

  Post({
    required this.postId,
    this.image,
    this.content,
    required this.createdAt,
    this.updatedAt,
    required this.authorUserId,
    required this.likesAmount,
    this.authorNickname,
    this.authorPhoto,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'] as String,
      image: json['image'] as String?,
      content: json['content'] as String?,
      createdAt: DateTime.parse(json['createdat'] as String),
      updatedAt: json['updatedat'] != null
          ? DateTime.parse(json['updatedat'] as String)
          : null,
      authorUserId: json['users_user_id'] as String,
      likesAmount: (json['likesamount'] as num?)?.toInt() ?? 0,
      authorNickname: json['author_nickname'] as String?,
      authorPhoto: json['author_photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'image': image,
      'content': content,
      'createdat': createdAt.toIso8601String(),
      'updatedat': updatedAt?.toIso8601String(),
      'users_user_id': authorUserId,
      'likesamount': likesAmount,
    };
  }

  Post copyWith({
    String? postId,
    String? image,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authorUserId,
    int? likesAmount,
    String? authorNickname,
    String? authorPhoto,
  }) {
    return Post(
      postId: postId ?? this.postId,
      image: image ?? this.image,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authorUserId: authorUserId ?? this.authorUserId,
      likesAmount: likesAmount ?? this.likesAmount,
      authorNickname: authorNickname ?? this.authorNickname,
      authorPhoto: authorPhoto ?? this.authorPhoto,
    );
  }

  @override
  String toString() {
    return 'Post(postId: $postId, authorUserId: $authorUserId, content: $content, likesAmount: $likesAmount, createdAt: $createdAt)';
  }
}
