import 'package:styla_mobile_app/features/community/domain/model/post.dart';

abstract class CommunityRepository {
  Future<Post> createPost({
    required String userId,
    required String outfitId,
    String? content,
  });

  Future<List<Post>> getFeedPosts();
}
