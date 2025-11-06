import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/occasion_option.dart';

abstract class WardrobeRepository {
  Future<Garment> addGarment({
    required String imagePath,
    required String categoryId,
    required List<String> tagIds,
    required String color,
    required String style,
    required String occasion,
    required String userId,
  });

  Future<List<Garment>> getGarments();

  Future<void> deleteGarment(String garmentId);

  Future<Garment> updateGarment(Garment garment);

  /// Update garment image
  Future<Garment> updateGarmentImage({
    required String garmentId,
    required String newImagePath,
  });

  /// Update garment category
  Future<Garment> updateGarmentCategory({
    required String garmentId,
    required String categoryId,
  });

  /// Update a specific field of a garment (color, style, occasion)
  Future<Garment> updateGarmentField({
    required String garmentId,
    required String field,
    required String value,
  });

  /// Update garment tags
  Future<Garment> updateGarmentTags({
    required String garmentId,
    required List<String> tagIds,
  });

  /// Get available categories for dropdown selection
  /// Returns list of Category domain models
  Future<List<Category>> getAvailableCategories();

  /// Get available tags for multi-selection
  /// Returns list of Tag domain models
  Future<List<Tag>> getAvailableTags();

  /// Find existing tag by name or create new one (for hybrid approach)
  /// Returns the Tag domain model
  Future<Tag> findOrCreateTag(String tagName);

  Future<List<Garment>> getFilteredGarments({
    String? category,
    List<String>? tags,
  });

  /// Get available color options from database
  Future<List<ColorOption>> getAvailableColors();

  /// Get available style options from database
  Future<List<StyleOption>> getAvailableStyles();

  /// Get available occasion options from database
  Future<List<OccasionOption>> getAvailableOccasions();
}
