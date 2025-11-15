import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class IsPostSavedUsecase {
  final CommunityRepository _communityRepository;

  IsPostSavedUsecase({required CommunityRepository communityRepository})
      : _communityRepository = communityRepository;

  Future<bool> execute({
    required String userId,
    required String postId,
  }) {
    return _communityRepository.isPostSaved(userId: userId, postId: postId);
  }
}
