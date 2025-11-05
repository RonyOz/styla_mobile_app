import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class UpdateGarmentCategoryUsecase {
  final WardrobeRepository _repository;

  UpdateGarmentCategoryUsecase({required WardrobeRepository repository})
    : _repository = repository;

  Future<Garment> execute({
    required String garmentId,
    required String categoryId,
  }) {
    return _repository.updateGarmentCategory(
      garmentId: garmentId,
      categoryId: categoryId,
    );
  }
}
