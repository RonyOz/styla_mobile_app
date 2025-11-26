import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/dress/domain/repository/dress_repository.dart';

class GetOutfitsUseCase {
  final DressRepository _dressRepository;

  GetOutfitsUseCase({required DressRepository dressRepository})
    : _dressRepository = dressRepository;

  Future<List<Outfit>> execute() {
    return _dressRepository.loadDressData();
  }
}
