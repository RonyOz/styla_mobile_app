import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Importa Supabase
import '../routes/app_routes.dart';
import '../services/onboarding_storage.dart';

/// Página de splash screen inicial
/// Se muestra mientras se cargan recursos o se verifica autenticación
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Esta espera es para que el splash sea visible. Puede ser más corta.
    await Future.delayed(const Duration(seconds: 1));

    if (kDebugMode) {
      await OnboardingStorage.reset();
      debugPrint('SplashPage: force onboarding in debug mode');
    }

    // 1. Check if user has completed onboarding for the current version
    final hasCompletedOnboarding = await OnboardingStorage.isCompleted();
    debugPrint('SplashPage: hasCompletedOnboarding = $hasCompletedOnboarding');

    if (!hasCompletedOnboarding) {
      // Go to onboarding if not completed
      debugPrint('SplashPage: Navigating to onboarding1');
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding1);
      }
      return;
    }

    // 3. Verificamos si hay una sesión de usuario activa
    final session = Supabase.instance.client.auth.currentSession;
    debugPrint('SplashPage: session = ${session != null}');

    // 4. Decidimos la ruta: si no hay sesión, vamos a welcome; si hay, a home.
    final nextRoute = session != null ? AppRoutes.home : AppRoutes.welcome;
    debugPrint('SplashPage: nextRoute = $nextRoute');

    if (mounted) {
      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


