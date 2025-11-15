import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class LikePostUsecase {
  final CommunityRepository _communityRepository;

  LikePostUsecase({required CommunityRepository communityRepository})
    : _communityRepository = communityRepository;

  Future<void> execute({required String postId}) {
    return _communityRepository.likePost(postId: postId);
  }
}
