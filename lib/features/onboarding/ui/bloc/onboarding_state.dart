import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';

enum OnboardingStatus { initial, loading, success, failure }

class OnboardingState {
  final int currentPage;
  final Profile data;
  final Preferences preferences;
  final OnboardingStatus status;
  final String? errorMessage;
  final List<ColorOption> availableColors;
  final List<StyleOption> availableStyles;

  OnboardingState({
    this.currentPage = 0,
    required this.data,
    required this.preferences,
    this.status = OnboardingStatus.initial,
    this.errorMessage,
    this.availableColors = const [],
    this.availableStyles = const [],
  });

  OnboardingState copyWith({
    int? currentPage,
    Profile? data,
    Preferences? preferences,
    OnboardingStatus? status,
    String? errorMessage,
    List<ColorOption>? availableColors,
    List<StyleOption>? availableStyles,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      preferences: preferences ?? this.preferences,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      availableColors: availableColors ?? this.availableColors,
      availableStyles: availableStyles ?? this.availableStyles,
    );
  }
}
