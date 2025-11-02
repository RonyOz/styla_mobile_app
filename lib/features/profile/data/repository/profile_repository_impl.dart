import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/profile/data/source/profile_data_source.dart';
import 'package:styla_mobile_app/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDataSource _profileDataSource = ProfileDataSourceImpl();
  
  @override
  Future<Profile> getProfile() {
    return _profileDataSource.getProfile();
  }

  @override
  String getCurrentUserId() {
    return _profileDataSource.getCurrentUserId();
  }
}

