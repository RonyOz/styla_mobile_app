import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

/// Use Case para eliminar una prenda
/// Responsabilidad: Encapsular la lógica de negocio para eliminar prendas
class DeleteGarmentUsecase {
  final WardrobeRepository _wardrobeRepository;

  DeleteGarmentUsecase({
    required WardrobeRepository wardrobeRepository,
  }) : _wardrobeRepository = wardrobeRepository;

  /// Ejecuta el caso de uso
  /// [garmentId]: ID de la prenda a eliminar
  Future<void> execute({required String garmentId}) {
    return _wardrobeRepository.deleteGarment(garmentId);
  }
}
