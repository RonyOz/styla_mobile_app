import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';
import 'package:styla_mobile_app/features/wardrobe/data/repository/wardrobe_repository_impl.dart';

class UpdateGarmentFieldUsecase {
  final WardrobeRepository _repository;

  UpdateGarmentFieldUsecase([WardrobeRepository? repository])
    : _repository = repository ?? WardrobeRepositoryImpl();

  Future<Garment> execute({
    required String garmentId,
    required String field,
    required String value,
  }) async {
    return await _repository.updateGarmentField(
      garmentId: garmentId,
      field: field,
      value: value,
    );
  }
}
