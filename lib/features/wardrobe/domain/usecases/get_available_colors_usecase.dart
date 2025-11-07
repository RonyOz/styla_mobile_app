import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class GetAvailableColorsUsecase {
  final WardrobeRepository _repository;

  GetAvailableColorsUsecase({required WardrobeRepository wardrobeRepository})
    : _repository = wardrobeRepository;

  Future<List<ColorOption>> execute() async {
    return await _repository.getAvailableColors();
  }
}
