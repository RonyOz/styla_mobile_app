import 'package:styla_mobile_app/features/profile/domain/repository/profile_repository.dart';

/// Use case to get the current authenticated user ID
class WhoAmIUsecase {
  final ProfileRepository _profileRepository;

  WhoAmIUsecase({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  /// Executes the use case and returns the current user ID
  /// Throws ProfileException if user is not authenticated
  String execute() {
    return _profileRepository.getCurrentUserId();
  }
}
