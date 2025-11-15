import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class GetSavedPostsUsecase {
  final CommunityRepository _communityRepository;

  GetSavedPostsUsecase({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  Future<List<Post>> execute({required String userId}) {
    return _communityRepository.getSavedPosts(userId: userId);
  }
}
