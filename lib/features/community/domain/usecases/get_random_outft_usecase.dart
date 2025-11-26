import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class GetRandomOutfitUseCase {
  final CommunityRepository communityRepository;

  GetRandomOutfitUseCase({required this.communityRepository});

  Future<List<Outfit>> execute() {
    return communityRepository.getRandomOutfits();
  }
}
