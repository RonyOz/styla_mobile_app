import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}

abstract class StorageDataSource {
  Future<String> uploadImage({
    required String imagePath,
    required String userId,
  });

  Future<void> deleteImage(String imageUrl);
}

class StorageDataSourceImpl implements StorageDataSource {
  final SupabaseClient _supabaseClient;
  static const String _bucketName = 'garment-images';

  StorageDataSourceImpl({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<String> uploadImage({
    required String imagePath,
    required String userId,
  }) async {
    try {
      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = imagePath.split('.').last;
      final fileName = '${userId}_$timestamp.$fileExtension';

      // Upload to Supabase Storage
      // Bucket path: garments/{userId}/{fileName}
      final storagePath = '$userId/$fileName';

      await _supabaseClient.storage
          .from(_bucketName)
          .upload(
            storagePath,
            File(imagePath), // FILE
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get public URL
      final imageUrl = _supabaseClient.storage
          .from(_bucketName)
          .getPublicUrl(storagePath);

      return imageUrl;
    } catch (e) {
      throw StorageException('Failed to upload image: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract storage path from public URL
      // URL format: https://.../storage/v1/object/public/garments/{userId}/{fileName}
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find 'garments' in path and get everything after it
      final bucketIndex = pathSegments.indexOf(_bucketName);
      if (bucketIndex == -1) {
        throw StorageException('Invalid image URL format');
      }

      // Build storage path: {userId}/{fileName}
      final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');

      await _supabaseClient.storage.from(_bucketName).remove([storagePath]);
    } catch (e) {
      throw StorageException('Failed to delete image: ${e.toString()}');
    }
  }
}
