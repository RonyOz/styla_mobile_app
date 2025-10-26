import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

/// Use Case para obtener todas las prendas del usuario
/// Responsabilidad: Encapsular la lógica de negocio para cargar prendas
class GetGarmentsUsecase {
  final WardrobeRepository _wardrobeRepository;

  GetGarmentsUsecase({
    required WardrobeRepository wardrobeRepository,
  }) : _wardrobeRepository = wardrobeRepository;

  /// Ejecuta el caso de uso
  /// Returns: Lista de prendas del usuario autenticado
  Future<List<Garment>> execute() {
    return _wardrobeRepository.getGarments();
  }
}
