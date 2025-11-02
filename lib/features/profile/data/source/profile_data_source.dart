import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileException implements Exception {
  final String message;
  ProfileException(this.message);

  @override
  String toString() => 'ProfileException: $message';
}

abstract class ProfileDataSource {
  Future<Profile> getProfile();
  
  /// Get current authenticated user ID
  String getCurrentUserId();
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final SupabaseClient _supabaseClient;

  ProfileDataSourceImpl({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  String getCurrentUserId() {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw ProfileException('User not authenticated');
    }
    return userId;
  }

  @override
  Future<Profile> getProfile() async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw ProfileException('User not authenticated');
      }

      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .single();
          
      return Profile.fromJson(response);

    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
         throw ProfileException('Profile not found. Please complete your profile.');
      }
      throw ProfileException('Failed to fetch profile: ${e.toString()}');
    }
  }
}