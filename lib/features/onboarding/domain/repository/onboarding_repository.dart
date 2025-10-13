import 'package:styla_mobile_app/features/onboarding/domain/entitites/onboarding_data.dart';

abstract class OnboardingRepository {
  /// Guarda los datos del perfil y las preferencias del usuario.
  /// Requiere el ID del usuario autenticado para vincular los datos.
  Future<void> saveOnboardingData(String userId, OnboardingData data);
}