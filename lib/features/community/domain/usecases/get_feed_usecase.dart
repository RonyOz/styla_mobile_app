import 'package:styla_mobile_app/features/community/domain/model/post.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class GetFeedUsecase {
  final CommunityRepository _communityRepository;

  GetFeedUsecase({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  Future<List<Post>> execute() {
    return _communityRepository.getFeedPosts();
  }
}
