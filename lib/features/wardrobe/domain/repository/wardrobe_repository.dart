import 'package:styla_mobile_app/core/domain/model/garment.dart';

abstract class WardrobeRepository {
  Future<Garment> addGarment({
    required String imagePath,
    required String category,
  });

  Future<List<Garment>> getGarments();
  
  Future<void> deleteGarment(String garmentId);
  
  Future<Garment> updateGarment(Garment garment);
}
