import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/onboarding_storage.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  Future<void> _setOnboarded(BuildContext context) async {
    final navigator = Navigator.of(context);
    await OnboardingStorage.markCompleted();
    navigator.pushReplacementNamed(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Skip button at top right
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: () => _setOnboarded(context),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Quote
                    Text(
                      '"Success isn\'t given. It\'s earned in the gym through commitment and hard work."',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Continue button at bottom right
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () => _setOnboarded(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Get Started'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
