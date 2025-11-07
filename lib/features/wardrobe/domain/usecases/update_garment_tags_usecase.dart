import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';
import 'package:styla_mobile_app/features/wardrobe/data/repository/wardrobe_repository_impl.dart';

class UpdateGarmentTagsUsecase {
  final WardrobeRepository _repository;

  UpdateGarmentTagsUsecase([WardrobeRepository? repository])
    : _repository = repository ?? WardrobeRepositoryImpl();

  Future<Garment> execute({
    required String garmentId,
    required List<String> tagIds,
  }) async {
    return await _repository.updateGarmentTags(
      garmentId: garmentId,
      tagIds: tagIds,
    );
  }
}
