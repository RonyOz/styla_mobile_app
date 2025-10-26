import 'package:flutter/material.dart';
import 'package:styla_mobile_app/app/pages/home/home_tab_navigator.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/community_tab.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/dashboard_tab.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/dress_up_tab.dart';
import 'package:styla_mobile_app/app/pages/home/tabs/wardrobe_tab.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/app/widgets/styla_bottom_nav.dart';

import '../layouts/main_layout.dart';

/// Pagina principal protegida por login con barra de navegacion inferior.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Navigator keys for each tab to maintain independent navigation stacks
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Inicio
    GlobalKey<NavigatorState>(), // Closet
    GlobalKey<NavigatorState>(), // Vestirse
    GlobalKey<NavigatorState>(), // Comunidad
  ];

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

  late final List<Widget> _pages = [
    HomeTabNavigator.build(
      key: _navigatorKeys[0],
      child: const DashboardTab(),
    ),
    HomeTabNavigator.build(
      key: _navigatorKeys[1],
      child: const WardrobeTab(),
    ),
    HomeTabNavigator.build(
      key: _navigatorKeys[2],
      child: const DressUpTab(),
    ),
    HomeTabNavigator.build(
      key: _navigatorKeys[3],
      child: const CommunityTab(),
    ),
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
        title: Text(_items[_currentIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Ir al perfil',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages), // Puede consumir mas recursos si las pages son pesadas.
      bottomNavigationBar: StylaBottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
