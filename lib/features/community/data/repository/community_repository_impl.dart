import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';
import 'package:styla_mobile_app/features/community/data/source/community_data_source.dart';

class CommunityRepositoryImpl extends CommunityRepository {
  final CommunityDataSource _communityDataSource;

  CommunityRepositoryImpl({
    CommunityDataSource? communityDataSource,
  }) : _communityDataSource =
            communityDataSource ?? CommunityDataSourceImpl();

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
}
