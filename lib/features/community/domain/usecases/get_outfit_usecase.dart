import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/community/domain/repository/community_repository.dart';

class GetOutfitUseCase {
  final CommunityRepository _communityRepository;

  GetOutfitUseCase({required CommunityRepository communityRepository})
    : _communityRepository = communityRepository;

  Future<List<Outfit>> execute() {
    return _communityRepository.getOutfits();
  }
}
