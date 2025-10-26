import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

/// Use Case para actualizar una prenda existente
/// Responsabilidad: Encapsular la lógica de negocio para actualizar prendas
class UpdateGarmentUsecase {
  final WardrobeRepository _wardrobeRepository;

  UpdateGarmentUsecase({
    required WardrobeRepository wardrobeRepository,
  }) : _wardrobeRepository = wardrobeRepository;

  /// Ejecuta el caso de uso
  /// [garment]: Prenda con los datos actualizados
  /// Returns: Prenda actualizada desde el servidor
  Future<Garment> execute({required Garment garment}) {
    return _wardrobeRepository.updateGarment(garment);
  }
}
