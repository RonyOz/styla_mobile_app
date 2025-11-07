import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class GetOneGarmentUsecase {
  final WardrobeRepository _wardrobeRepository;

  GetOneGarmentUsecase({required WardrobeRepository wardrobeRepository})
    : _wardrobeRepository = wardrobeRepository;

  Future<Garment> execute(String garmentId) {
    return _wardrobeRepository.getGarmentById(garmentId);
  }
}
