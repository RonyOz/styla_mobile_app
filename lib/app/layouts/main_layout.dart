import 'package:flutter/material.dart';

/// Layout principal de la aplicación
/// Contiene la estructura base: AppBar, Drawer, BottomNavigationBar, etc.
class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: const Text('Styla Mobile App'),
          ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
