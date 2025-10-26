import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

/// Use Case para obtener las categorías disponibles
/// Responsabilidad: Encapsular la lógica de negocio para cargar categorías
class GetAvailableCategoriesUsecase {
  final WardrobeRepository _wardrobeRepository;

  GetAvailableCategoriesUsecase({
    required WardrobeRepository wardrobeRepository,
  }) : _wardrobeRepository = wardrobeRepository;

  /// Ejecuta el caso de uso
  /// Returns: Lista de categorías disponibles desde el repositorio
  Future<List<Category>> execute() {
    return _wardrobeRepository.getAvailableCategories();
  }
}
