import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';

class GetUserStatsUsecase {
  final _repository = CommunityRepositoryImpl();

  Future<Map<String, int>> execute({required String userId}) async {
    return await _repository.getUserStats(userId: userId);
  }
}
