import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class GetMostLikedOutfitsUseCase {
  final CommunityRepository communityRepository;

  GetMostLikedOutfitsUseCase({required this.communityRepository});

  Future<List<Outfit>> call() async {
    return communityRepository.getMostLikedOutfits();
  }
}