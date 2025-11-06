import 'package:styla_mobile_app/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';

class GetAvailableColorsUsecase {
  final OnboardingRepository _repository;

  GetAvailableColorsUsecase({required OnboardingRepository repository})
    : _repository = repository;

  Future<List<ColorOption>> execute() async {
    return await _repository.getAvailableColors();
  }
}
