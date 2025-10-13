import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/onboarding_storage.dart';
import '../layouts/onboarding_layout.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  Future<void> _handleSkip(BuildContext context) async {
    final navigator = Navigator.of(context);
    await OnboardingStorage.markCompleted();
    navigator.pushReplacementNamed(AppRoutes.welcome);
  }

  Future<void> _goToNext(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pushReplacementNamed(AppRoutes.onboarding3);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      headline: 'Inspirate, combina y crea tu estilo cada día',
      // body removed to match the prototype
      body: null,
      currentStep: 1,
      totalSteps: 3,
      primaryActionLabel: 'Continuar',
      onPrimaryAction: () => _goToNext(context),
      onSkip: () => _handleSkip(context),

      // NEW: background asset for this screen
      backgroundAsset: 'assets/images/backgrounds/welcome2.png',
      // Optional: tweak contrast if needed
      // overlayColor: Colors.black.withOpacity(0.28),
    );
  }
}
