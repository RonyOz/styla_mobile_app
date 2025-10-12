import 'package:styla_mobile_app/features/onboarding/data/source/onboarding_data_source.dart';
import 'package:styla_mobile_app/features/onboarding/domain/entitites/onboarding_data.dart';
import 'package:styla_mobile_app/features/onboarding/domain/repository/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingDataSource _dataSource;

  OnboardingRepositoryImpl(this._dataSource);

  @override
  Future<void> saveOnboardingData(String userId, OnboardingData data) {
    return _dataSource.saveOnboardingData(userId, data);
  }
}