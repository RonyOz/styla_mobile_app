import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';
import 'package:styla_mobile_app/features/community/domain/model/post.dart';

class GetUserPostsUsecase {
  final _repository = CommunityRepositoryImpl();

  Future<List<Post>> execute({required String userId}) async {
    return await _repository.getUserPosts(userId: userId);
  }
}
