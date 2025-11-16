import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';
import 'package:styla_mobile_app/features/community/domain/model/user_profile.dart';

class GetUserProfileUsecase {
  final _repository = CommunityRepositoryImpl();

  Future<UserProfile> execute({required String userId}) async {
    return await _repository.getUserProfile(userId: userId);
  }
}
