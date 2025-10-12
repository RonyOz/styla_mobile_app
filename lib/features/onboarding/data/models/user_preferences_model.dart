import 'package:styla_mobile_app/features/onboarding/domain/entitites/user_preferences.dart';

class UserPreferencesModel extends UserPreferences {
  UserPreferencesModel({
    required super.style,
    required super.preferredColor,
    required super.preferredImage,
  });

  // Asumo que la tabla 'PREFERENCES' tiene una estructura similar a esto. [cite: 1] (obvio esto es gemini)
  // También asumo que se crea una nueva preferencia y se asocia al perfil
  // a través de la tabla intermedia 'PROFILES_PREFERENCES'. [cite: 1] (x2)
  Map<String, dynamic> toJson() {
    return {
      // Asumo que 'name' en la tabla PREFERENCES corresponde al estilo o color.
      // Para simplificar, guardaremos las preferencias en la tabla PROFILES por ahora.
      // Esta decisión se puede refinar más adelante.
      'style_preference': style,
      'color_preference': preferredColor,
      'image_preference': preferredImage,
    };
  }
}