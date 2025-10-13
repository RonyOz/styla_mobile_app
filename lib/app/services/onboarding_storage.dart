import 'package:shared_preferences/shared_preferences.dart';

/// Centralizes how onboarding completion is persisted.
class OnboardingStorage {
  OnboardingStorage._();

  static const _completedVersionKey = 'onboarding_version';
  static const _legacyCompletedKey = 'onboarded';

  /// Increase this value whenever the onboarding flow changes in a way
  /// that users should see it again.
  static const int currentVersion = 2;

  /// Returns true when the stored onboarding version matches the current one.
  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt(_completedVersionKey) ?? 0;

    // When the stored version is behind, treat onboarding as incomplete.
    if (storedVersion < currentVersion) {
      return false;
    }

    return true;
  }

  /// Persists the onboarding as completed for the current version.
  static Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_completedVersionKey, currentVersion);

    // Maintain the legacy flag for any code that might still read it.
    await prefs.setBool(_legacyCompletedKey, true);
  }

  /// Helper for manual resets during development.
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedVersionKey);
    await prefs.remove(_legacyCompletedKey);
  }
}
