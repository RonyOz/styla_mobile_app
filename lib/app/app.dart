import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

/// Widget raíz de la aplicación
/// Configura el tema, rutas y configuraciones globales
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Styla Mobile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRouter.routes,
    );
  }
}
