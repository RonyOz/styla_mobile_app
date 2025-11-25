import 'dart:convert';
import 'dart:typed_data';

import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

abstract class DressDataSource {
  Future<void> saveDressData(
    String name,
    String description,
    String promptId,
    String shirt,
    String pants,
    String? shoes,
  );

  Future<List<Outfit>> loadDressData();
  Future<String> uploadGeneratedImage(Uint8List bytes, String userId);
  Future<List<Garment>> loadGarmentsData();
}

class DressDataSourceImpl implements DressDataSource {
  final SupabaseClient _supabaseClient;

  DressDataSourceImpl({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<void> saveDressData(
    String name,
    String description,
    String promptId,
    String shirt,
    String pants,
    String? shoes,
  ) async {
    // Aquí podrías implementar la lógica para subir las imágenes a un servicio de almacenamiento
    // y obtener las URLs correspondientes. Por simplicidad, asumiremos que ya tienes las URLs

    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    if (shoes == null) {
      shoes = '';
    }

    final response = await http.post(
      Uri.parse("https://styla-generator.onrender.com/generate-outfit"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "prompt": "prompt",
        "camisa_url": shirt,
        "pantalon_url": pants,
        "zapatos_url": shoes,
      }),
    );

    final json = jsonDecode(response.body);
    print("Respuesta del servidor: ${json["image_base64"].length} caracteres");
    Uint8List bytes = base64Decode(json["image_base64"]);

    final imageUrl = await uploadGeneratedImage(bytes, userId);

    Outfit newOutfit = Outfit(
      name: name,
      description: description,
      createdAt: DateTime.now().toIso8601String(),
      userId: userId,
      promptId: promptId,
      imageUrl: imageUrl,
    );

    await _supabaseClient.from('outfits').insert(newOutfit.toJson());
  }

  @override
  Future<List<Outfit>> loadDressData() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabaseClient
        .from('outfits')
        .select()
        .eq('users_user_id', userId)
        .order('created_at', ascending: false);
    //print("holaaaaaaaaaa");
    // print(response.toString());

    return (response as List).map((json) => Outfit.fromJson(json)).toList();
  }

  @override
  Future<String> uploadGeneratedImage(Uint8List bytes, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${userId}_$timestamp.png';
      final storagePath = '$userId/$fileName';

      await _supabaseClient.storage
          .from('garment-images')
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = _supabaseClient.storage
          .from('garment-images')
          .getPublicUrl(storagePath);

      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload generated image: ${e.toString()}');
    }
  }

  @override
  Future<List<Garment>> loadGarmentsData() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabaseClient
        .from('garments')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Garment.fromJson(json)).toList();
  }

  Future<String?> uploadGeneratedImageToSupabase(
    Uint8List bytes,
    String userId,
  ) async {
    print("binary length: ${bytes.length}");
    final fileName = "${userId}_${DateTime.now().millisecondsSinceEpoch}.png";
    final path = "$userId/$fileName";

    await _supabaseClient.storage
        .from("garment-images")
        .uploadBinary(path, bytes);

    return _supabaseClient.storage.from("garment-images").getPublicUrl(path);
  }
}
