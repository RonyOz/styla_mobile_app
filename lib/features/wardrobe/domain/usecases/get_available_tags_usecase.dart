import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

/// Use Case para obtener los tags disponibles
/// Responsabilidad: Encapsular la lógica de negocio para cargar tags
class GetAvailableTagsUsecase {
  final WardrobeRepository _wardrobeRepository;

  GetAvailableTagsUsecase({
    required WardrobeRepository wardrobeRepository,
  }) : _wardrobeRepository = wardrobeRepository;

  /// Ejecuta el caso de uso
  /// Returns: Lista de tags disponibles desde el repositorio
  Future<List<Tag>> execute() {
    return _wardrobeRepository.getAvailableTags();
  }
}
