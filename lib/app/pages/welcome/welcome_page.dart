import 'package:flutter/material.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/core/ui/design/app_colors.dart';
import 'package:styla_mobile_app/core/ui/design/app_spacing.dart';
import 'package:styla_mobile_app/core/ui/widgets/app_button.dart';
import 'package:styla_mobile_app/core/ui/widgets/app_image.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_background.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback: color de fondo si la imagen no existe
                return Container(color: AppColors.background);
              },
            ),
          ),

          // Overlay semi-transparente para opacidad
          Positioned.fill(child: Container(color: Colors.black54)),

          // Contenido sobre el background
          SafeArea(
            child: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Espacio superior (2 partes)
                    const Spacer(flex: 2),

                    // Logo centrado
                    AppLogo(width: 360, height: 240),

                    // Espacio entre logo y botones (1 parte)
                    const Spacer(flex: 1),

                  // Botones aproximadamente en 3/4 de la pantalla
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: AppButton.primary(
                      text: 'Iniciar sesión',
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.login),
                    ),
                  ),

                  AppSpacing.verticalMedium,

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: AppButton.secondary(
                      text: 'Registrarse',
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.signup),
                    ),
                  ),

                  // Espacio inferior (1 parte)
                  const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
