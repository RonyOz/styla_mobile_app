import 'package:styla_mobile_app/features/community/domain/model/post.dart';

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
}
