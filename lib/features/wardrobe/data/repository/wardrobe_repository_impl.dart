import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/data/source/wardrobe_data_source.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class WardrobeRepositoryImpl extends WardrobeRepository {
  final WardrobeDataSource _wardrobeDataSource;

  WardrobeRepositoryImpl({WardrobeDataSource? wardrobeDataSource})
      : _wardrobeDataSource = wardrobeDataSource ?? WardrobeDataSourceImpl();

  @override
  Future<Garment> addGarment({
    required String imagePath,
    required String category,
  }) {
    return _wardrobeDataSource.addGarment(
      imagePath: imagePath,
      category: category,
    );
  }

  @override
  Future<List<Garment>> getGarments() {
    return _wardrobeDataSource.getGarments();
  }

  @override
  Future<void> deleteGarment(String garmentId) {
    return _wardrobeDataSource.deleteGarment(garmentId);
  }

  @override
  Future<Garment> updateGarment(Garment garment) {
    return _wardrobeDataSource.updateGarment(garment);
  }
}
