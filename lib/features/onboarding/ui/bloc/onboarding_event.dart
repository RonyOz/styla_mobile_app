import 'package:styla_mobile_app/features/onboarding/domain/entitites/onboarding_data.dart';

abstract class OnboardingEvent {}

class NextPageRequested extends OnboardingEvent {}

class PreviousPageRequested extends OnboardingEvent {}

class GenderSelected extends OnboardingEvent {
  final Gender gender;
  GenderSelected(this.gender);
}

class MeasurementsUpdated extends OnboardingEvent {
  final int age;
  final int height;
  final int weight;
  MeasurementsUpdated({required this.age, required this.height, required this.weight});
}

class StyleSelected extends OnboardingEvent {
  final String style;
  StyleSelected(this.style);
}

class AdditionalInfoUpdated extends OnboardingEvent {
  final String color;
  final String imagePreference;
  AdditionalInfoUpdated({required this.color, required this.imagePreference});
}

class ProfileInfoUpdated extends OnboardingEvent {
  final String fullName;
  final String nickname;
  final String phoneNumber;
  ProfileInfoUpdated({required this.fullName, required this.nickname, required this.phoneNumber});
}

class SubmitOnboarding extends OnboardingEvent {}