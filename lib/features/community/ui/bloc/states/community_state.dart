import 'package:styla_mobile_app/features/community/domain/model/post.dart';

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
