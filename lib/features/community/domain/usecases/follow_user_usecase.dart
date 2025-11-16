import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';

class FollowUserUsecase {
  final _repository = CommunityRepositoryImpl();

  Future<void> execute({
    required String followerUserId,
    required String followedUserId,
  }) async {
    await _repository.followUser(
      followerUserId: followerUserId,
      followedUserId: followedUserId,
    );
  }
}
