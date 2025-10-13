// features/onboarding/ui/pages/onboarding_setup_page.dart
import 'package:flutter/material.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import '../../../core/core.dart';

class OnboardingSetupPage extends StatelessWidget {
  const OnboardingSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.50,
              child: Image.asset(
                'assets/images/backgrounds/setup.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Soft overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                    Colors.black.withOpacity(0.45),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Stack(
                children: [
                  // Top bar (Back & Skip)
                  Row(
                    children: [
                      
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          //TODO: FIX - CHANGE ROUTE TO ONBOARDING SCREEN 4.1 A - GENDER 
                          AppRoutes.login,
                        ),
                        label: const Text('Omitir'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: AppTypography.button.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                        ),
                      ),
                    ],
                  ),

                 // Body
                  Column(
                    children: [
                      const Spacer(flex: 3),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Styla: Tu Armario,\nReinventado',
                          textAlign: TextAlign.center,
                          style: AppTypography.title.copyWith(
                            color: AppColors.primary,
                            height: 1.15,
                            fontSize: 34, 
                            fontWeight: FontWeight.w800, 
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),

        
                      const SizedBox(height: 28),

                      // Subtitle / body (más abajo)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Text(
                            'Transforma tu guardarropa en infinitas posibilidades, '
                            'descubre nuevas combinaciones y expresa tu estilo '
                            'único cada día con Styla',
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              color: Colors.white.withOpacity(0.92),
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 4),
                    ],
                  ),


                  // Bottom-right CTA (outlined in mock)
                  Positioned(
                    right: 0,
                    bottom: 40,
                    child: IntrinsicWidth(
                      child: AppButton.secondary(
                        text: 'Siguiente',
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.onboarding1,
                        ),
                        // If your AppButton supports an icon like in Signin:
                        icon: Icons
                            .arrow_forward, // safe to remove if not supported
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
