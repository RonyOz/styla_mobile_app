class Comment {
  final String commentId;
  final String content;
  final DateTime createdAt;
  final String postId;
  final String authorUserId;

  // Información del autor (join con profiles)
  final String? authorNickname;
  final String? authorPhoto;

  Comment({
    required this.commentId,
    required this.content,
    required this.createdAt,
    required this.postId,
    required this.authorUserId,
    this.authorNickname,
    this.authorPhoto,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdat'] as String),
      postId: json['post_id'] as String,
      authorUserId: json['author_user_id'] as String,
      authorNickname: json['author_nickname'] as String?,
      authorPhoto: json['author_photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'content': content,
      'createdat': createdAt.toIso8601String(),
      'post_id': postId,
      'author_user_id': authorUserId,
    };
  }

  Comment copyWith({
    String? commentId,
    String? content,
    DateTime? createdAt,
    String? postId,
    String? authorUserId,
    String? authorNickname,
    String? authorPhoto,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      authorUserId: authorUserId ?? this.authorUserId,
      authorNickname: authorNickname ?? this.authorNickname,
      authorPhoto: authorPhoto ?? this.authorPhoto,
    );
  }

  @override
  String toString() {
    return 'Comment(commentId: $commentId, postId: $postId, authorUserId: $authorUserId, content: $content)';
  }
}
