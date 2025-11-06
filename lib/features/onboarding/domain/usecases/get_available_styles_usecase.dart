import 'package:styla_mobile_app/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';

class GetAvailableStylesUsecase {
  final OnboardingRepository _repository;

  GetAvailableStylesUsecase({required OnboardingRepository repository})
    : _repository = repository;

  Future<List<StyleOption>> execute() async {
    return await _repository.getAvailableStyles();
  }
}
