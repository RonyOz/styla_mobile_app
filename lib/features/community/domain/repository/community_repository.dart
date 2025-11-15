import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/model/comment.dart';

abstract class CommunityRepository {
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
}
