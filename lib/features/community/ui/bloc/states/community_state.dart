import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/model/comment.dart';

abstract class CommunityState {}

class CommunityIdleState extends CommunityState {}

class CommunityLoadingState extends CommunityState {}

class FeedLoadedState extends CommunityState {
  final List<Post> posts;

  FeedLoadedState({required this.posts});
}

class PostCreatedState extends CommunityState {
  final Post post;

  PostCreatedState({required this.post});
}

class CommunityErrorState extends CommunityState {
  final String message;

  CommunityErrorState({required this.message});
}

// UC013 - Like
class PostLikedState extends CommunityState {
  final String postId;

  PostLikedState({required this.postId});
}

// UC014 - Comentarios
class CommentsLoadedState extends CommunityState {
  final List<Comment> comments;
  final String postId;

  CommentsLoadedState({required this.comments, required this.postId});
}

class CommentCreatedState extends CommunityState {
  final Comment comment;

  CommentCreatedState({required this.comment});
}

class SavedPostsLoadedState extends CommunityState {
  final List<Post> savedPosts;

  SavedPostsLoadedState({required this.savedPosts});
}

class PostSavedState extends CommunityState {}

class PostUnsavedState extends CommunityState {}

class OutfitLoadedState extends CommunityState {
  final List<Outfit> outfits;

  OutfitLoadedState({required this.outfits});
}

class OutfitLoadErrorState extends CommunityState {
  final String message;

  OutfitLoadErrorState({required this.message});
}

class OutfitLoadingState extends CommunityState {}
