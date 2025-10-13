import 'package:flutter/material.dart';
import 'package:styla_mobile_app/app/layouts/onboarding_layout.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/app/services/onboarding_storage.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  Future<void> _handleComplete(BuildContext context) async {
    final navigator = Navigator.of(context);
    await OnboardingStorage.markCompleted();
    navigator.pushReplacementNamed(AppRoutes.welcome);
  }

  Future<void> _goToNext(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pushReplacementNamed(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      headline: 'Tu closet tiene más de lo que imaginas',
      // body removed to match the prototype
      body: null,
      currentStep: 3,
      totalSteps: 3,
      primaryActionLabel: 'Continuar',
      onPrimaryAction: () => _goToNext(context),
      onSkip: () => _handleComplete(context),

      // NEW: background asset for this screen
      backgroundAsset: 'assets/images/backgrounds/welcome3.png',
      // Optional: tweak contrast if needed
      // overlayColor: Colors.black.withOpacity(0.28),
    );
  }
}
