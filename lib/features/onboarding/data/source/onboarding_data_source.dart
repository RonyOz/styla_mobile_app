import 'package:styla_mobile_app/features/onboarding/domain/entitites/onboarding_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class OnboardingDataSource {
  Future<void> saveOnboardingData(String userId, OnboardingData data);
}

class OnboardingDataSourceImpl implements OnboardingDataSource {
  final SupabaseClient _supabaseClient;

  OnboardingDataSourceImpl({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<void> saveOnboardingData(String userId, OnboardingData data) async {
    try {
      // Basado en el modelo relacional, actualizaremos la tabla 'PROFILES'. [cite: 1]
      // El registro en 'PROFILES' se debería crear al momento del SignUp,
      // aquí solo lo actualizamos con la información del onboarding.
      await _supabaseClient.from('profiles').update({
        'nickname': data.nickname, // [cite: 1]
        'photo': null, // La foto de perfil se puede añadir después. [cite: 1]
        'telephone_number': data.phoneNumber,
        // 'birthdate' podría calcularse a partir de la edad, pero lo omitimos por simplicidad. [cite: 1]
        'weight': data.weight, // [cite: 1]
        'height': data.height, // [cite: 1]
        'gender': data.gender?.name, // Asumo que hay una columna 'gender' en 'profiles'.

        // Asunción: Para simplificar, guardaremos las preferencias como columnas
        // adicionales en la tabla 'profiles'. El modelo relacional sugiere una
        // tabla 'PREFERENCES' separada, pero esto requeriría una lógica más compleja
        // para manejar la relación many-to-many que podemos implementar más adelante. [cite: 1]
        'style_preference': data.preferences?.style,
        'color_preference': data.preferences?.preferredColor,
        'image_preference': data.preferences?.preferredImage,
        'full_name': data.fullName, // Asumo que hay una columna 'full_name'.
      }).eq('user_id', userId); // La PK en la tabla 'PROFILES' es 'User_ID'. [cite: 1]

    } catch (e) {
      // Manejar el error apropiadamente
      throw Exception('Failed to save onboarding data: $e');
    }
  }
}