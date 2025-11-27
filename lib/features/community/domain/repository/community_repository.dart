import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/model/comment.dart';
import 'package:styla_mobile_app/features/community/domain/model/user_profile.dart';

abstract class CommunityRepository {
  Future<List<Outfit>> getOutfits();

  Future<Post> createPost({
    required String userId,
    required String outfitId,
    String? content,
  });

  Future<List<Post>> getFeedPosts();

  Future<void> savePost({required String userId, required String postId});

  Future<void> unsavePost({required String userId, required String postId});

  Future<List<Post>> getSavedPosts({required String userId});

  Future<bool> isPostSaved({required String userId, required String postId});

  // UC013 - Dar like a post
  Future<void> likePost({required String postId});

  // UC014 - Comentarios
  Future<List<Comment>> getComments({required String postId});

  Future<Comment> createComment({
    required String postId,
    required String authorUserId,
    required String content,
  });

  // UC016 & UC017 - Perfil de usuario y seguir/dejar de seguir
  Future<UserProfile> getUserProfile({required String userId});

  Future<List<Post>> getUserPosts({required String userId});

  Future<Map<String, int>> getUserStats({required String userId});

  Future<bool> isFollowing({
    required String followerUserId,
    required String followedUserId,
  });

  Future<void> followUser({
    required String followerUserId,
    required String followedUserId,
  });

  Future<void> unfollowUser({
    required String followerUserId,
    required String followedUserId,
  });

  Future<List<Outfit>> getRandomOutfits();

  Future<List<Outfit>> getMostLikedOutfits();
}
