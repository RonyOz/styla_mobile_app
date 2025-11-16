import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';

class UnfollowUserUsecase {
  final _repository = CommunityRepositoryImpl();

  Future<void> execute({
    required String followerUserId,
    required String followedUserId,
  }) async {
    await _repository.unfollowUser(
      followerUserId: followerUserId,
      followedUserId: followedUserId,
    );
  }
}
