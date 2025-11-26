import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class GetRandomOutfitUseCase {
  final WardrobeRepository wardrobeRepository;

  GetRandomOutfitUseCase({required this.wardrobeRepository});

  Future<List<Outfit>> execute() {
    return wardrobeRepository.getRandomOutfits();
  }
}
