import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class SavePostUsecase {
  final CommunityRepository _communityRepository;

  SavePostUsecase({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  Future<void> execute({
    required String userId,
    required String postId,
  }) {
    return _communityRepository.savePost(userId: userId, postId: postId);
  }
}
