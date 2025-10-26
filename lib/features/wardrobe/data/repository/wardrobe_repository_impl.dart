import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';
import 'package:styla_mobile_app/features/wardrobe/data/source/wardrobe_data_source.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

class WardrobeRepositoryImpl extends WardrobeRepository {
  final WardrobeDataSource _wardrobeDataSource;

  WardrobeRepositoryImpl({WardrobeDataSource? wardrobeDataSource})
      : _wardrobeDataSource = wardrobeDataSource ?? WardrobeDataSourceImpl();

  @override
  Future<Garment> addGarment({
    required String imagePath,
    required String categoryId,
    required List<String> tagIds,
  }) {
    return _wardrobeDataSource.addGarment(
      imagePath: imagePath,
      categoryId: categoryId,
      tagIds: tagIds,
    );
  }

  @override
  Future<List<Garment>> getGarments() {
    return _wardrobeDataSource.getGarments();
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
  Future<List<Category>> getAvailableCategories() async {
    // DataSource retorna DTOs (Map), Repository transforma a Domain Models
    final dtos = await _wardrobeDataSource.getAvailableCategories();
    return dtos
        .map((dto) => Category(
              id: dto['id']!,
              name: dto['name']!,
            ))
        .toList();
  }

  @override
  Future<List<Tag>> getAvailableTags() async {
    // DataSource retorna DTOs (Map), Repository transforma a Domain Models
    final dtos = await _wardrobeDataSource.getAvailableTags();
    return dtos
        .map((dto) => Tag(
              id: dto['id']!,
              name: dto['name']!,
            ))
        .toList();
  }

  @override
  Future<Tag> findOrCreateTag(String tagName) async {
    // DataSource retorna DTO (Map), Repository transforma a Domain Model
    final dto = await _wardrobeDataSource.findOrCreateTag(tagName);
    return Tag(
      id: dto['id']!,
      name: dto['name']!,
    );
  }
}
