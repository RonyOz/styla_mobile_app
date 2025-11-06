import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/data/repository/wardrobe_repository_impl.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class GetFilteredUsecase {
  final WardrobeRepository repository = WardrobeRepositoryImpl();

  Future<List<Garment>> execute({String? category, List<String>? tags}) {
    return repository.getFilteredGarments(category: category, tags: tags);
  }
}
