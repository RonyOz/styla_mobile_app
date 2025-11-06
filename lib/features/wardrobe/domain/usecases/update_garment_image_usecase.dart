import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class UpdateGarmentImageUsecase {
  final WardrobeRepository _repository;

  UpdateGarmentImageUsecase({required WardrobeRepository repository})
    : _repository = repository;

  Future<Garment> execute({
    required String garmentId,
    required String newImagePath,
  }) {
    return _repository.updateGarmentImage(
      garmentId: garmentId,
      newImagePath: newImagePath,
    );
  }
}
