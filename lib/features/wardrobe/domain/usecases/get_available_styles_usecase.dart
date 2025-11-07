import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class GetAvailableStylesUsecase {
  final WardrobeRepository _repository;

  GetAvailableStylesUsecase({required WardrobeRepository wardrobeRepository})
    : _repository = wardrobeRepository;

  Future<List<StyleOption>> execute() async {
    return await _repository.getAvailableStyles();
  }
}
