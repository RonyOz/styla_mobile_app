import 'package:styla_mobile_app/features/onboarding/domain/entitites/onboarding_data.dart';

enum OnboardingStatus { initial, loading, success, failure }

class OnboardingState {
  final int currentPage;
  final OnboardingData data;
  final OnboardingStatus status;
  final String? errorMessage;

  OnboardingState({
    this.currentPage = 0,
    required this.data,
    this.status = OnboardingStatus.initial,
    this.errorMessage,
  });

  OnboardingState copyWith({
    int? currentPage,
    OnboardingData? data,
    OnboardingStatus? status,
    String? errorMessage,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}