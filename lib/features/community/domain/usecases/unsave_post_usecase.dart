import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class UnsavePostUsecase {
  final CommunityRepository _communityRepository;

  UnsavePostUsecase({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  Future<void> execute({
    required String userId,
    required String postId,
  }) {
    return _communityRepository.unsavePost(userId: userId, postId: postId);
  }
}
