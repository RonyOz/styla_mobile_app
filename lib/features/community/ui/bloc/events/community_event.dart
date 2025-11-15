abstract class CommunityEvent {}

class LoadFeedRequested extends CommunityEvent {}

class CreatePostRequested extends CommunityEvent {
  final String userId;
  final String outfitId;
  final String? content;

  CreatePostRequested({
    required this.userId,
    required this.outfitId,
    this.content,
  });
}

// UC013 - Dar like a post
class LikePostRequested extends CommunityEvent {
  final String postId;

  LikePostRequested({required this.postId});
}

// UC014 - Comentarios
class LoadCommentsRequested extends CommunityEvent {
  final String postId;

  LoadCommentsRequested({required this.postId});
}

class CreateCommentRequested extends CommunityEvent {
  final String postId;
  final String authorUserId;
  final String content;

  CreateCommentRequested({
    required this.postId,
    required this.authorUserId,
    required this.content,
  });
}

class SavePostRequested extends CommunityEvent {
  final String userId;
  final String postId;

  SavePostRequested({required this.userId, required this.postId});
}

class UnsavePostRequested extends CommunityEvent {
  final String userId;
  final String postId;

  UnsavePostRequested({required this.userId, required this.postId});
}

class LoadSavedPostsRequested extends CommunityEvent {
  final String userId;

  LoadSavedPostsRequested({required this.userId});
}
