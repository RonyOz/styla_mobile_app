import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WardrobeException implements Exception {
  final String message;
  WardrobeException(this.message);

  @override
  String toString() => 'WardrobeException: $message';
}

abstract class WardrobeDataSource {
  Future<Garment> addGarment({
    required String imagePath,
    required String category,
  });

  Future<List<Garment>> getGarments();
  
  Future<void> deleteGarment(String garmentId);
  
  Future<Garment> updateGarment(Garment garment);
}

class WardrobeDataSourceImpl extends WardrobeDataSource {
  final SupabaseClient _supabaseClient;

  WardrobeDataSourceImpl({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<Garment> addGarment({
    required String imagePath,
    required String category,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw WardrobeException('User not authenticated');
      }

      // TODO: Implementar subida de imagen a Supabase Storage
      // final imageUrl = await _uploadImage(imagePath);

      final garmentData = {
        'user_id': userId,
        'image_url': imagePath, // Temporal, cambiar por imageUrl
        'category': category,
        'tags': <String>[],
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabaseClient
          .from('garments')
          .insert(garmentData)
          .select()
          .single();

      return Garment.fromJson(response);
    } catch (e) {
      throw WardrobeException('Failed to add garment: ${e.toString()}');
    }
  }

  @override
  Future<List<Garment>> getGarments() async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw WardrobeException('User not authenticated');
      }

      final response = await _supabaseClient
          .from('garments')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Garment.fromJson(json))
          .toList();
    } catch (e) {
      throw WardrobeException('Failed to fetch garments: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteGarment(String garmentId) async {
    try {
      await _supabaseClient
          .from('garments')
          .delete()
          .eq('id', garmentId);
    } catch (e) {
      throw WardrobeException('Failed to delete garment: ${e.toString()}');
    }
  }

  @override
  Future<Garment> updateGarment(Garment garment) async {
    try {
      final response = await _supabaseClient
          .from('garments')
          .update(garment.toJson())
          .eq('id', garment.id)
          .select()
          .single();

      return Garment.fromJson(response);
    } catch (e) {
      throw WardrobeException('Failed to update garment: ${e.toString()}');
    }
  }
}
