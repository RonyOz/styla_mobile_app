import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

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
            title: Text(
              'Styla Mobile App',
              style: AppTypography.subtitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
