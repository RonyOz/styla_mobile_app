import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/onboarding/data/source/onboarding_data_source.dart';
import 'package:styla_mobile_app/features/onboarding/domain/repository/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingDataSource _dataSource;

  OnboardingRepositoryImpl(this._dataSource);

  @override
  Future<void> saveOnboardingData(
    String userId,
    Profile data,
    Preferences preferences,
  ) {
    return _dataSource.saveOnboardingData(userId, data, preferences);
  }
}
