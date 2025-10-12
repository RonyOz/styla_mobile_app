import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Importa Supabase
import '../routes/app_routes.dart';

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
    
    // 2. Verificamos si hay una sesión de usuario activa
    final session = Supabase.instance.client.auth.currentSession;
    
    // 3. Decidimos la ruta: si no hay sesión, vamos a login; si hay, a home.
    final nextRoute = session != null ? AppRoutes.home : AppRoutes.login;
    
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