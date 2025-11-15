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
