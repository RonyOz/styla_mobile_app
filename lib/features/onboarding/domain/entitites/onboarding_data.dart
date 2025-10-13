import 'package:styla_mobile_app/features/onboarding/domain/entitites/user_preferences.dart';

enum Gender { female, male, other }

class OnboardingData {
  // Datos del Perfil
  final String fullName;
  final String nickname;
  final String phoneNumber;
  final Gender? gender;
  final int? age;
  final int? height; // en cm
  final int? weight; // en kg

  // Datos de Preferencias
  final UserPreferences? preferences;

  OnboardingData({
    this.fullName = '',
    this.nickname = '',
    this.phoneNumber = '',
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.preferences,
  });

  OnboardingData copyWith({
    String? fullName,
    String? nickname,
    String? phoneNumber,
    Gender? gender,
    int? age,
    int? height,
    int? weight,
    UserPreferences? preferences,
  }) {
    return OnboardingData(
      fullName: fullName ?? this.fullName,
      nickname: nickname ?? this.nickname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      preferences: preferences ?? this.preferences,
    );
  }
}