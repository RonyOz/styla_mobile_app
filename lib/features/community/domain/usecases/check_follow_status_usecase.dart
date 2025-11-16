import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';

class CheckFollowStatusUsecase {
  final _repository = CommunityRepositoryImpl();

  Future<bool> execute({
    required String followerUserId,
    required String followedUserId,
  }) async {
    return await _repository.isFollowing(
      followerUserId: followerUserId,
      followedUserId: followedUserId,
    );
  }
}
