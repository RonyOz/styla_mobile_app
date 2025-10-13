import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../routes/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLarge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              // Logo principal
              Center(
                child: AppLogo(
                  width: 180,
                  height: 120,
                ),
              ),
              
              AppSpacing.verticalLarge,
              
              // Botón de login usando nuestro SimpleButton
              AppButton.primary(
                text: 'Iniciar sesión',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
              
              AppSpacing.verticalMedium,
              
              // Botón de registro usando SimpleButton secundario
              AppButton.secondary(
                text: 'Registrarse',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
              ),
              
              AppSpacing.verticalLarge,
            ],
          ),
        ),
      ),
    );
  }
}