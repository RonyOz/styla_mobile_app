import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/profile/domain/repository/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository _profileRepository;

  GetProfileUsecase({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  Future<Profile> execute() {
    return _profileRepository.getProfile();
  }
}