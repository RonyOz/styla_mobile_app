import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/dress/domain/repository/dress_repository.dart';

class GetGarmentsUsecase {
  final DressRepository _dressRepository;

  GetGarmentsUsecase({required DressRepository dressRepository})
    : _dressRepository = dressRepository;

  Future<List<Garment>> execute() {
    return _dressRepository.loadGarmentsData();
  }
}
