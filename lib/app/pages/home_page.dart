import 'package:flutter/material.dart';
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

  late final List<StylaBottomNavItem> _items = [
    const StylaBottomNavItem(
      label: 'Inicio',
      icon:
          'assets/icon/inicio.svg',
      activeIcon:
          'assets/icon/icon-active/inicio_active.svg',
    ),
    const StylaBottomNavItem(
      label: 'Closet',
      icon: 'assets/icon/closet2.svg',
      activeIcon: 'assets/icon/icon-active/closet2_active.svg', 
    ),
    const StylaBottomNavItem(
      label: 'Vestirse',
      icon:
          'assets/icon/vestirse.svg', 
      activeIcon: 'assets/icon/icon-active/vestirse_active.svg',
    ),
    const StylaBottomNavItem(
      label: 'Comunidad',
      icon: 'assets/icon/comunidad.svg',
      activeIcon: 'assets/icon/icon-active/comunidad_active.svg',
    ),
  ];

  late final List<Widget> _pages = const [
    _HomeDashboardView(),
    _ClosetPlaceholderView(),
    _DressUpPlaceholderView(),
    _CommunityPlaceholderView(),
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
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: StylaBottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  const _HomeDashboardView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Inicio'));
  }
}

class _ClosetPlaceholderView extends StatelessWidget {
  const _ClosetPlaceholderView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Closet'));
  }
}

class _DressUpPlaceholderView extends StatelessWidget {
  const _DressUpPlaceholderView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Vestirse'));
  }
}

class _CommunityPlaceholderView extends StatelessWidget {
  const _CommunityPlaceholderView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Comunidad'));
  }
}
