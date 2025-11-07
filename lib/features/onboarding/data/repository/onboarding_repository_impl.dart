import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/onboarding/data/source/onboarding_data_source.dart';
import 'package:styla_mobile_app/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';

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

  @override
  Future<List<ColorOption>> getAvailableColors() async {
    final data = await _dataSource.getAvailableColors();
    return data.map((item) => ColorOption.fromJson(item)).toList();
  }

  @override
  Future<List<StyleOption>> getAvailableStyles() async {
    final data = await _dataSource.getAvailableStyles();
    return data.map((item) => StyleOption.fromJson(item)).toList();
  }
}
