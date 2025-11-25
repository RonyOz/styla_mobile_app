import 'package:styla_mobile_app/features/dress/domain/repository/dress_repository.dart';

class AddOutfitUsecase {
  final DressRepository _dressRepository;

  AddOutfitUsecase({required DressRepository dressRepository})
    : _dressRepository = dressRepository;

  Future<void> execute({
    required String name,
    required String description,
    required String promptId,
    required String shirt,
    required String pants,
    String? shoes,
  }) {
    return _dressRepository.saveDressData(
      name,
      description,
      promptId,
      shirt,
      pants,
      shoes,
    );
  }
}
