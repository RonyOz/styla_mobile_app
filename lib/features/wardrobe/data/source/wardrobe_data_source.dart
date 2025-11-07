import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WardrobeException implements Exception {
  final String message;
  WardrobeException(this.message);

  @override
  String toString() => 'WardrobeException: $message';
}

abstract class WardrobeDataSource {
  /// Add garment with imageUrl already uploaded
  Future<Garment> addGarmentWithImageUrl({
    required String imageUrl,
    required String categoryId,
    required List<String> tagIds,
    required String color,
    required String style,
    required String occasion,
  });

  Future<List<Garment>> getGarments();

  Future<void> deleteGarment(String garmentId);

  Future<Garment> updateGarment(Garment garment);

  Future<Garment> updateGarmentImage({
    required String garmentId,
    required String newImageUrl,
  });

  Future<Garment> updateGarmentCategory({
    required String garmentId,
    required String categoryId,
  });

  Future<Garment> updateGarmentField({
    required String garmentId,
    required String field,
    required String value,
  });

  Future<Garment> updateGarmentTags({
    required String garmentId,
    required List<String> tagIds,
  });

  Future<List<Map<String, String>>> getAvailableCategories();

  Future<List<Map<String, String>>> getAvailableTags();

  /// Find existing tag by name or create new one (for hybrid approach)
  /// Returns DTO with 'id' and 'name'
  Future<Map<String, String>> findOrCreateTag(String tagName);

  Future<List<Garment>> getFilteredGarments({
    String? category,
    List<String>? tags,
  });

  Future<Garment> getGarmentById(String garmentId);

  Future<List<Map<String, String>>> getAvailableColors();

  Future<List<Map<String, String>>> getAvailableStyles();

  Future<List<Map<String, String>>> getAvailableOccasions();
}

class WardrobeDataSourceImpl extends WardrobeDataSource {
  final SupabaseClient _supabaseClient;

  WardrobeDataSourceImpl({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  String getCurrentUserId() {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw WardrobeException('User not authenticated');
    }
    return userId;
  }

  @override
  Future<Garment> addGarmentWithImageUrl({
    required String imageUrl,
    required String categoryId,
    required List<String> tagIds,
    required String color,
    required String style,
    required String occasion,
  }) async {
    try {
      final userId = getCurrentUserId();

      // 1. Insert garment with garment_category_id
      final garmentResponse = await _supabaseClient
          .from('garments')
          .insert({
            'user_id': userId,
            'image_url': imageUrl,
            'garment_category_id': categoryId,
            'color': color,
            'style': style,
            'ocasion': occasion,
            'created_at': DateTime.now().toIso8601String().split('T')[0],
          })
          .select()
          .single();

      final garmentId = garmentResponse['id'] as String;

      // 2. Insert tags in garment_tags junction table
      if (tagIds.isNotEmpty) {
        final garmentTagsData = tagIds
            .map((tagId) => {'garment_id': garmentId, 'tag_id': tagId})
            .toList();

        await _supabaseClient.from('garment_tags').insert(garmentTagsData);
      }

      // 3. Fetch complete garment with JOINs to get names
      return await getGarmentById(garmentId);
    } catch (e) {
      print(e.toString());
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

      // Query with JOINs to get category name and tag names
      final response = await _supabaseClient
          .from('garments')
          .select('''
            id,
            user_id,
            image_url,
            created_at,
            color,
            style,
            ocasion,
            category:garment_categories(name),
            tags:garment_tags(tag:tags(name))
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => _mapToGarment(json)).toList();
    } catch (e) {
      throw WardrobeException('Failed to fetch garments: ${e.toString()}');
    }
  }

  @override
  Future<Garment> getGarmentById(String garmentId) async {
    final response = await _supabaseClient
        .from('garments')
        .select('''
          id,
          user_id,
          image_url,
          created_at,
          color,
          style,
          ocasion,
          category:garment_categories(name),
          tags:garment_tags(tag:tags(name))
        ''')
        .eq('id', garmentId)
        .single();

    return _mapToGarment(response);
  }

  Garment _mapToGarment(Map<String, dynamic> json) {
    // Extract category name from nested object
    final categoryName = json['category'] != null
        ? (json['category'] as Map<String, dynamic>)['name'] as String
        : '';

    // Extract tag names from nested array
    final tagNames =
        (json['tags'] as List?)
            ?.map((t) => (t['tag'] as Map<String, dynamic>)['name'] as String)
            .toList() ??
        <String>[];

    return Garment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      categoryName: categoryName,
      tagNames: tagNames,
      createdAt: DateTime.parse(json['created_at'] as String),
      color: json['color'] as String? ?? '',
      style: json['style'] as String? ?? '',
      occasion: json['ocasion'] as String? ?? '',
    );
  }

  @override
  Future<List<Map<String, String>>> getAvailableCategories() async {
    try {
      final response = await _supabaseClient
          .from('garment_categories')
          .select('category_id, name')
          .order('name');

      return (response as List)
          .map(
            (c) => {
              'id': c['category_id'] as String,
              'name': c['name'] as String,
            },
          )
          .toList();
    } catch (e) {
      throw WardrobeException('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, String>>> getAvailableTags() async {
    try {
      final response = await _supabaseClient
          .from('tags')
          .select('tag_id, name')
          .order('name');

      return (response as List)
          .map(
            (t) => {'id': t['tag_id'] as String, 'name': t['name'] as String},
          )
          .toList();
    } catch (e) {
      throw WardrobeException('Failed to fetch tags: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, String>> findOrCreateTag(String tagName) async {
    try {
      final trimmedName = tagName.trim();
      if (trimmedName.isEmpty) {
        throw WardrobeException('Tag name cannot be empty');
      }

      // Normalize for search: case-insensitive
      final normalized = trimmedName.toLowerCase();

      // Check if tag already exists (case-insensitive)
      final existing = await _supabaseClient
          .from('tags')
          .select('tag_id, name')
          .ilike('name', normalized)
          .maybeSingle();

      if (existing != null) {
        return {
          'id': existing['tag_id'] as String,
          'name': existing['name'] as String,
        };
      }

      // Create new tag (preserve original casing)
      final newTag = await _supabaseClient
          .from('tags')
          .insert({'name': trimmedName})
          .select('tag_id, name')
          .single();

      return {
        'id': newTag['tag_id'] as String,
        'name': newTag['name'] as String,
      };
    } catch (e) {
      throw WardrobeException('Failed to find or create tag: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteGarment(String garmentId) async {
    try {
      // Delete from garment_tags first (foreign key constraint)
      await _supabaseClient
          .from('garment_tags')
          .delete()
          .eq('garment_id', garmentId);

      // Then delete the garment
      await _supabaseClient.from('garments').delete().eq('id', garmentId);
    } catch (e) {
      throw WardrobeException('Failed to delete garment: ${e.toString()}');
    }
  }

  @override
  Future<Garment> updateGarment(Garment garment) async {
    try {
      // Note: For MVP, we're not supporting category/tag updates
      // Only image_url can be updated
      final response = await _supabaseClient
          .from('garments')
          .update({'image_url': garment.imageUrl})
          .eq('id', garment.id)
          .select()
          .single();

      return await getGarmentById(response['id']);
    } catch (e) {
      throw WardrobeException('Failed to update garment: ${e.toString()}');
    }
  }

  @override
  Future<List<Garment>> getFilteredGarments({
    String? category,
    List<String>? tags,
  }) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) throw WardrobeException("User not authenticated");

      // Start with base query including JOINs for category and tags
      var query = _supabaseClient
          .from('garments')
          .select('''
            id,
            user_id,
            image_url,
            created_at,
            color,
            style,
            ocasion,
            garment_category_id,
            category:garment_categories(name),
            tags:garment_tags(tag:tags(name))
          ''')
          .eq('user_id', userId);

      // ✅ Filtro por categoría
      if (category != null && category.isNotEmpty) {
        final categoryData = await _supabaseClient
            .from('garment_categories')
            .select('category_id')
            .eq('name', category)
            .maybeSingle();
        if (categoryData != null) {
          query = query.eq('garment_category_id', categoryData['category_id']);
        }
      }

      // ✅ Filtro por tags (uno o varios)
      if (tags != null && tags.isNotEmpty) {
        final tagRows = await _supabaseClient
            .from('tags')
            .select('tag_id')
            .inFilter('name', tags); // usar in_ para múltiples

        final tagIds = (tagRows as List).map((e) => e['tag_id']).toList();
        if (tagIds.isNotEmpty) {
          final garmentTagRows = await _supabaseClient
              .from('garment_tags')
              .select('garment_id')
              .inFilter('tag_id', tagIds);

          final garmentIds = (garmentTagRows as List)
              .map((e) => e['garment_id'])
              .toList();

          if (garmentIds.isEmpty) {
            return []; // no hay matching tags → devolvemos vacío
          }

          query = query.inFilter('id', garmentIds);
        }
      }

      // Finalmente ordenar y ejecutar
      final result = await query.order('created_at', ascending: false);
      print("Resultado final: $result");
      return (result as List).map((json) => _mapToGarment(json)).toList();
    } catch (e) {
      throw WardrobeException("Failed to filter garments: $e");
    }
  }

  @override
  Future<Garment> updateGarmentImage({
    required String garmentId,
    required String newImageUrl,
  }) async {
    try {
      await _supabaseClient
          .from('garments')
          .update({'image_url': newImageUrl})
          .eq('id', garmentId);

      return await getGarmentById(garmentId);
    } catch (e) {
      throw WardrobeException(
        'Failed to update garment image: ${e.toString()}',
      );
    }
  }

  @override
  Future<Garment> updateGarmentCategory({
    required String garmentId,
    required String categoryId,
  }) async {
    try {
      await _supabaseClient
          .from('garments')
          .update({'garment_category_id': categoryId})
          .eq('id', garmentId);

      return await getGarmentById(garmentId);
    } catch (e) {
      throw WardrobeException(
        'Failed to update garment category: ${e.toString()}',
      );
    }
  }

  @override
  Future<Garment> updateGarmentField({
    required String garmentId,
    required String field,
    required String value,
  }) async {
    try {
      // Validar que el campo sea uno de los permitidos
      if (!['color', 'style', 'occasion'].contains(field)) {
        throw WardrobeException('Invalid field: $field');
      }

      await _supabaseClient
          .from('garments')
          .update({field: value})
          .eq('id', garmentId);

      return await getGarmentById(garmentId);
    } catch (e) {
      throw WardrobeException(
        'Failed to update garment $field: ${e.toString()}',
      );
    }
  }

  @override
  Future<Garment> updateGarmentTags({
    required String garmentId,
    required List<String> tagIds,
  }) async {
    try {
      // 1. Eliminar todas las tags actuales del garment
      await _supabaseClient
          .from('garment_tags')
          .delete()
          .eq('garment_id', garmentId);

      // 2. Insertar las nuevas tags
      if (tagIds.isNotEmpty) {
        final garmentTags = tagIds
            .map((tagId) => {'garment_id': garmentId, 'tag_id': tagId})
            .toList();

        await _supabaseClient.from('garment_tags').insert(garmentTags);
      }

      // 3. Retornar el garment actualizado con las nuevas tags
      return await getGarmentById(garmentId);
    } catch (e) {
      throw WardrobeException('Failed to update garment tags: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, String>>> getAvailableColors() async {
    try {
      final response = await _supabaseClient
          .from('colors')
          .select('id, name')
          .order('name');

      return (response as List)
          .map(
            (item) => {
              'id': item['id'].toString(),
              'name': item['name'].toString(),
            },
          )
          .toList();
    } catch (e) {
      throw WardrobeException('Failed to fetch colors: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, String>>> getAvailableStyles() async {
    try {
      final response = await _supabaseClient
          .from('styles')
          .select('id, name')
          .order('name');

      return (response as List)
          .map(
            (item) => {
              'id': item['id'].toString(),
              'name': item['name'].toString(),
            },
          )
          .toList();
    } catch (e) {
      throw WardrobeException('Failed to fetch styles: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, String>>> getAvailableOccasions() async {
    try {
      final response = await _supabaseClient
          .from('occasions')
          .select('id, name')
          .order('name');

      return (response as List)
          .map(
            (item) => {
              'id': item['id'].toString(),
              'name': item['name'].toString(),
            },
          )
          .toList();
    } catch (e) {
      throw WardrobeException('Failed to fetch occasions: ${e.toString()}');
    }
  }
}
