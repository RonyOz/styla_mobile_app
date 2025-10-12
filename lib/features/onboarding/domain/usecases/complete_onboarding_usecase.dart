import 'package:styla_mobile_app/features/onboarding/domain/entitites/onboarding_data.dart';
import 'package:styla_mobile_app/features/onboarding/domain/repository/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<void> execute(String userId, OnboardingData data) {
    return _repository.saveOnboardingData(userId, data);
  }
}