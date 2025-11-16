import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/model/comment.dart';
import 'package:styla_mobile_app/features/community/domain/model/user_profile.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';
import 'package:styla_mobile_app/features/community/data/source/community_data_source.dart';

class CommunityRepositoryImpl extends CommunityRepository {
  final CommunityDataSource _communityDataSource;

  CommunityRepositoryImpl({CommunityDataSource? communityDataSource})
    : _communityDataSource = communityDataSource ?? CommunityDataSourceImpl();

  @override
  Future<Post> createPost({
    required String userId,
    required String outfitId,
    String? content,
  }) async {
    try {
      return await _communityDataSource.createPost(
        userId: userId,
        content: content,
        outfitId: outfitId,
      );
    } catch (e) {
      throw Exception('Failed to create post: ${e.toString()}');
    }
  }

  @override
  Future<List<Post>> getFeedPosts() {
    return _communityDataSource.getFeedPosts();
  }

  @override
  Future<void> savePost({required String userId, required String postId}) {
    return _communityDataSource.savePost(userId: userId, postId: postId);
  }

  @override
  Future<void> unsavePost({required String userId, required String postId}) {
    return _communityDataSource.unsavePost(userId: userId, postId: postId);
  }

  @override
  Future<List<Post>> getSavedPosts({required String userId}) {
    return _communityDataSource.getSavedPosts(userId: userId);
  }

  @override
  Future<bool> isPostSaved({required String userId, required String postId}) {
    return _communityDataSource.isPostSaved(userId: userId, postId: postId);
  }

  @override
  Future<void> likePost({required String postId}) {
    return _communityDataSource.likePost(postId: postId);
  }

  @override
  Future<List<Comment>> getComments({required String postId}) {
    return _communityDataSource.getComments(postId: postId);
  }

  @override
  Future<Comment> createComment({
    required String postId,
    required String authorUserId,
    required String content,
  }) {
    return _communityDataSource.createComment(
      postId: postId,
      authorUserId: authorUserId,
      content: content,
    );
  }

  @override
  Future<UserProfile> getUserProfile({required String userId}) {
    return _communityDataSource.getUserProfile(userId: userId);
  }

  @override
  Future<List<Post>> getUserPosts({required String userId}) {
    return _communityDataSource.getUserPosts(userId: userId);
  }

  @override
  Future<Map<String, int>> getUserStats({required String userId}) {
    return _communityDataSource.getUserStats(userId: userId);
  }

  @override
  Future<bool> isFollowing({
    required String followerUserId,
    required String followedUserId,
  }) {
    return _communityDataSource.isFollowing(
      followerUserId: followerUserId,
      followedUserId: followedUserId,
    );
  }

  @override
  Future<void> followUser({
    required String followerUserId,
    required String followedUserId,
  }) {
    return _communityDataSource.followUser(
      followerUserId: followerUserId,
      followedUserId: followedUserId,
    );
  }

  @override
  Future<void> unfollowUser({
    required String followerUserId,
    required String followedUserId,
  }) {
    return _communityDataSource.unfollowUser(
      followerUserId: followerUserId,
      followedUserId: followedUserId,
    );
  }
}
