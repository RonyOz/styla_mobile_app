import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/profile/ui/bloc/profile_bloc.dart';
import 'package:styla_mobile_app/features/profile/ui/screens/profile_screen.dart';
import '../pages/home_page.dart';
import '../pages/splash_page.dart';
import 'app_routes.dart';

/// Configuración del router de la aplicación
/// Usa el sistema de navegación básico de Flutter
class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.splash: (context) => const SplashPage(),
      AppRoutes.home: (context) => const HomePage(),
      AppRoutes.profile: (context) => BlocProvider(
        create: (_) => ProfileBloc(),
        child: const ProfileScreen(),
      ),
      // TODO: Agregar rutas de features (auth, profile, etc)
    };
  }

  /// Genera rutas dinámicas para navegación avanzada
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Aquí puedes manejar rutas con parámetros
    switch (settings.name) {
      default:
        return null;
    }
  }

  /// Ruta de error cuando no se encuentra una ruta
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) =>
          const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
    );
  }
}
