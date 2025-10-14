import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class OnboardingDataSource {
  Future<void> saveOnboardingData(
    String userId,
    Profile data,
    Preferences preferences,
  );
}

class OnboardingDataSourceImpl implements OnboardingDataSource {
  final SupabaseClient _supabaseClient;

  OnboardingDataSourceImpl({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<void> saveOnboardingData(
    String userId,
    Profile data,
    Preferences preferences,
  ) async {
    try {
      // Basado en el modelo relacional, actualizaremos la tabla 'PROFILES'. [cite: 1]
      // El registro en 'PROFILES' se debería crear al momento del SignUp,
      // aquí solo lo actualizamos con la información del onboarding.
      final response = await _supabaseClient
          .from('profiles')
          .insert(data.toJson())
          .select()
          .single();

      if (response.isEmpty) {
        throw Exception('Error insertando post');
      }

      final insertedProfile = await _supabaseClient
          .from('preferences')
          .insert(preferences.toJson())
          .select()
          .single();

      if (insertedProfile.isEmpty) {
        throw Exception('Error insertando preferences');
      }

      await _supabaseClient.from('profiles_preferences').insert({
        'profiles_user_id': response['user_id'],
        'preferences_preference_id': insertedProfile['preference_id'],
      });

      //'style_preference': data.preferences?.style,
      //'color_preference': data.preferences?.preferredColor,
      //'image_preference': data.preferences?.preferredImage,
    } catch (e) {
      // Manejar el error apropiadamente
      throw Exception('Failed to save onboarding data: $e');
    }
  }
}
