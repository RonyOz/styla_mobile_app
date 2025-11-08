import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/community_tab.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/dashboard_tab.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/dress_up_tab.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/wardrobe_tab.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/app/widgets/styla_bottom_nav.dart';
import 'package:styla_mobile_app/core/core.dart';

import '../layouts/main_layout.dart';

/// Pagina principal protegida por login con barra de navegacion inferior.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<StylaBottomNavItem> _items = [
    const StylaBottomNavItem(
      label: 'Inicio',
      icon: 'assets/icon/inicio.svg',
      activeIcon: 'assets/icon/icon-active/inicio_active.svg',
    ),
    const StylaBottomNavItem(
      label: 'Closet',
      icon: 'assets/icon/closet2.svg',
      activeIcon: 'assets/icon/icon-active/closet2_active.svg',
    ),
    const StylaBottomNavItem(
      label: 'Vestirse',
      icon: 'assets/icon/vestirse.svg',
      activeIcon: 'assets/icon/icon-active/vestirse_active.svg',
    ),
    const StylaBottomNavItem(
      label: 'Comunidad',
      icon: 'assets/icon/comunidad.svg',
      activeIcon: 'assets/icon/icon-active/comunidad_active.svg',
    ),
  ];

  late final List<Widget> _pages = const [
    DashboardTab(),
    WardrobeTab(),
    DressUpTab(),
    CommunityTab(),
  ];

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 48, // Más delgado (default es 56)
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        // Título minimalista
        title: Text(
          _items[_currentIndex].label,
          style: AppTypography.body.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        centerTitle: false, // Alineado a la izquierda para look minimalista
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_outline,
              size: 22, // Icono más pequeño
              color: AppColors.textPrimary,
            ),
            tooltip: 'Ir al perfil',
            padding: const EdgeInsets.symmetric(horizontal: 12),
            constraints: const BoxConstraints(), // Remover padding extra
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ), // Puede consumir mas recursos si las pages son pesadas.
      bottomNavigationBar: StylaBottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
