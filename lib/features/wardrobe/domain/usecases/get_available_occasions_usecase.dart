import 'package:styla_mobile_app/features/wardrobe/domain/model/occasion_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class GetAvailableOccasionsUsecase {
  final WardrobeRepository _repository;

  GetAvailableOccasionsUsecase({required WardrobeRepository wardrobeRepository})
    : _repository = wardrobeRepository;

  Future<List<OccasionOption>> execute() async {
    return await _repository.getAvailableOccasions();
  }
}
