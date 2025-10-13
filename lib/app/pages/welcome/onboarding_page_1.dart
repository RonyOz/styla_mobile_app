import 'package:flutter/material.dart';
import 'package:styla_mobile_app/app/layouts/onboarding_layout.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/app/services/onboarding_storage.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  Future<void> _handleSkip(BuildContext context) async {
    final navigator = Navigator.of(context);
    await OnboardingStorage.markCompleted();
    navigator.pushReplacementNamed(AppRoutes.welcome);
  }

  Future<void> _goToNext(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pushReplacementNamed(AppRoutes.onboarding2);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      headline: 'Descubre nuevas formas de ser tú, con lo que ya tienes',
      // body removed to match the prototype
      body: null,
      currentStep: 1,
      totalSteps: 3,
      primaryActionLabel: 'Continuar',
      onPrimaryAction: () => _goToNext(context),
      onSkip: () => _handleSkip(context),
      // NEW: background asset for this screen
      backgroundAsset: 'assets/images/backgrounds/welcome1.png',
      // Optional: tweak contrast if needed
      // overlayColor: Colors.black.withOpacity(0.28),
    );
  }
}
