import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/dress/data/source/dress_data_source.dart';
import 'package:styla_mobile_app/features/dress/domain/repository/dress_repository.dart';

class DressRepositoryImpl extends DressRepository {
  final DressDataSource _dataSource;

  DressRepositoryImpl({required DressDataSource? dressDataSource})
    : _dataSource = dressDataSource ?? DressDataSourceImpl();

  @override
  Future<void> saveDressData(
    String name,
    String description,
    String promptId,
    String shirt,
    String pants,
    String? shoes,
  ) {
    return _dataSource.saveDressData(
      name,
      description,
      promptId,
      shirt,
      pants,
      shoes,
    );
  }

  @override
  Future<List<Outfit>> loadDressData() {
    return _dataSource.loadDressData();
  }

  @override
  Future<List<Garment>> loadGarmentsData() {
    return _dataSource.loadGarmentsData();
  }
}
