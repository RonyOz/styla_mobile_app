import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';
import 'package:styla_mobile_app/features/wardrobe/data/source/wardrobe_data_source.dart';
import 'package:styla_mobile_app/features/wardrobe/data/source/storage_data_source.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class WardrobeRepositoryImpl extends WardrobeRepository {
  final WardrobeDataSource _wardrobeDataSource;
  final StorageDataSource _storageDataSource;

  WardrobeRepositoryImpl({
    WardrobeDataSource? wardrobeDataSource,
    StorageDataSource? storageDataSource,
  }) : _wardrobeDataSource = wardrobeDataSource ?? WardrobeDataSourceImpl(),
       _storageDataSource = storageDataSource ?? StorageDataSourceImpl();

  @override
  Future<Garment> addGarment({
    required String imagePath,
    required String categoryId,
    required List<String> tagIds,
    required String color,
    required String style,
    required String occasion,
    required String userId,
  }) async {
    try {
      // 1. Primero subir la imagen al Storage
      final imageUrl = await _storageDataSource.uploadImage(
        imagePath: imagePath,
        userId: userId,
      );

      // 2. Luego guardar el garment en la DB con la URL de la imagen
      return await _wardrobeDataSource.addGarmentWithImageUrl(
        imageUrl: imageUrl,
        categoryId: categoryId,
        tagIds: tagIds,
        color: color,
        style: style,
        occasion: occasion,
      );
    } on StorageException catch (e) {
      throw Exception('Failed to upload image: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add garment: ${e.toString()}');
    }
  }

  @override
  Future<List<Garment>> getGarments() {
    return _wardrobeDataSource.getGarments();
  }

  @override
  Future<Garment> getGarmentById(String garmentId) {
    return _wardrobeDataSource.getGarmentById(garmentId);
  }

  @override
  Future<void> deleteGarment(String garmentId) {
    return _wardrobeDataSource.deleteGarment(garmentId);
  }

  @override
  Future<Garment> updateGarment(Garment garment) {
    return _wardrobeDataSource.updateGarment(garment);
  }

  @override
  Future<Garment> updateGarmentImage({
    required String garmentId,
    required String newImagePath,
  }) async {
    try {
      // 1. Get current garment to get old image URL
      final garments = await _wardrobeDataSource.getGarments();
      final currentGarment = garments.firstWhere((g) => g.id == garmentId);

      // 2. Upload new image
      final newImageUrl = await _storageDataSource.uploadImage(
        imagePath: newImagePath,
        userId: currentGarment.userId,
      );

      // 3. Delete old image from storage (optional, to save space)
      if (currentGarment.imageUrl.isNotEmpty) {
        try {
          await _storageDataSource.deleteImage(currentGarment.imageUrl);
        } catch (e) {
          // Log but don't fail if old image can't be deleted
          print('Warning: Could not delete old image: $e');
        }
      }

      // 4. Update garment with new image URL
      return await _wardrobeDataSource.updateGarmentImage(
        garmentId: garmentId,
        newImageUrl: newImageUrl,
      );
    } on StorageException catch (e) {
      throw Exception('Failed to upload new image: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update garment image: ${e.toString()}');
    }
  }

  @override
  Future<Garment> updateGarmentCategory({
    required String garmentId,
    required String categoryId,
  }) async {
    try {
      return await _wardrobeDataSource.updateGarmentCategory(
        garmentId: garmentId,
        categoryId: categoryId,
      );
    } catch (e) {
      throw Exception('Failed to update garment category: ${e.toString()}');
    }
  }

  @override
  Future<List<Category>> getAvailableCategories() async {
    // DataSource retorna DTOs (Map), Repository transforma a Domain Models
    final dtos = await _wardrobeDataSource.getAvailableCategories();
    return dtos
        .map((dto) => Category(id: dto['id']!, name: dto['name']!))
        .toList();
  }

  @override
  Future<List<Tag>> getAvailableTags() async {
    // DataSource retorna DTOs (Map), Repository transforma a Domain Models
    final dtos = await _wardrobeDataSource.getAvailableTags();
    return dtos.map((dto) => Tag(id: dto['id']!, name: dto['name']!)).toList();
  }

  @override
  Future<Tag> findOrCreateTag(String tagName) async {
    // DataSource retorna DTO (Map), Repository transforma a Domain Model
    final dto = await _wardrobeDataSource.findOrCreateTag(tagName);
    return Tag(id: dto['id']!, name: dto['name']!);
  }

  Future<List<Garment>> getFilteredGarments({
    String? category,
    List<String>? tags,
  }) {
    return _wardrobeDataSource.getFilteredGarments(
      category: category,
      tags: tags,
    );
  }
}
