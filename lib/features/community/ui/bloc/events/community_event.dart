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
