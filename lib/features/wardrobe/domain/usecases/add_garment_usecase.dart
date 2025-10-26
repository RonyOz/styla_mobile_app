import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class AddGarmentUsecase {
  final WardrobeRepository _wardrobeRepository;

  AddGarmentUsecase({required WardrobeRepository wardrobeRepository})
      : _wardrobeRepository = wardrobeRepository;

  Future<Garment> execute({
    required String imagePath,
    required String categoryId,
    required List<String> tagIds,
  }) {
    return _wardrobeRepository.addGarment(
      imagePath: imagePath,
      categoryId: categoryId,
      tagIds: tagIds,
    );
  }
}
