import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';

abstract class DressRepository {
  Future<void> saveDressData(
    String name,
    String description,
    String promptId,
    String shirt,
    String pants,
    String? shoes,
  );

  Future<List<Outfit>> loadDressData();
  Future<List<Garment>> loadGarmentsData();
}
