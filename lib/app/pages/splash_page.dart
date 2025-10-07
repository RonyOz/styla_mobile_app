import 'package:flutter/material.dart';
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
    // TODO: Inicializar dependencias, verificar auth, etc.
    await Future.delayed(const Duration(seconds: 2));
    
    // TODO: Navegar a home o login según estado de autenticación
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
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
