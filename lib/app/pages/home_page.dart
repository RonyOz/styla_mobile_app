import 'package:flutter/material.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart'; // Importa las rutas
import '../layouts/main_layout.dart';

/// Página principal de la aplicación
/// Dashboard o home después del login
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: AppBar(
        title: const Text('Styla Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Ir al Perfil',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: const Center(child: Text('Home Page')),
    );
  }
}
