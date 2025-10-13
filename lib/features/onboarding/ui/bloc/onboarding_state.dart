import 'package:styla_mobile_app/core/domain/model/preferences.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';

enum OnboardingStatus { initial, loading, success, failure }

class OnboardingState {
  final int currentPage;
  final Profile data;
  final Preferences preferences;
  final OnboardingStatus status;
  final String? errorMessage;

  OnboardingState({
    this.currentPage = 0,
    required this.data,
    required this.preferences,
    this.status = OnboardingStatus.initial,
    this.errorMessage,
  });

  OnboardingState copyWith({
    int? currentPage,
    Profile? data,
    Preferences? preferences,
    OnboardingStatus? status,
    String? errorMessage,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      preferences: preferences ?? this.preferences,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
