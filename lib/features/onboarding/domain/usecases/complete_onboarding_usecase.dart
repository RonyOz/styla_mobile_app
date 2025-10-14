import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/onboarding/domain/repository/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<void> execute(String userId, Profile data, Preferences preferences) {
    data.id =
        userId; // Asegura que el ID del perfil coincida con el ID del usuario
    data.birthdate = DateTime.now();
    return _repository.saveOnboardingData(userId, data, preferences);
  }
}
