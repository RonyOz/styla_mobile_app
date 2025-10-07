import 'package:flutter/material.dart';
import '../layouts/main_layout.dart';

/// Página principal de la aplicación
/// Dashboard o home después del login
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
