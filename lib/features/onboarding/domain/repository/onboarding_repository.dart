import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';

abstract class OnboardingRepository {
  /// Guarda los datos del perfil y las preferencias del usuario.
  /// Requiere el ID del usuario autenticado para vincular los datos.
  Future<void> saveOnboardingData(
    String userId,
    Profile data,
    Preferences preferences,
  );

  /// Obtiene la lista de colores disponibles desde la base de datos
  Future<List<ColorOption>> getAvailableColors();

  /// Obtiene la lista de estilos disponibles desde la base de datos
  Future<List<StyleOption>> getAvailableStyles();
}
