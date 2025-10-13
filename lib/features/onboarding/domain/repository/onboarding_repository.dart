import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';

abstract class OnboardingRepository {
  /// Guarda los datos del perfil y las preferencias del usuario.
  /// Requiere el ID del usuario autenticado para vincular los datos.
  Future<void> saveOnboardingData(
    String userId,
    Profile data,
    Preferences preferences,
  );
}
