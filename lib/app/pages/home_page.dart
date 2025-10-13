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
          Icons.home_outlined, // TODO: replace with custom Inicio outline icon
      activeIcon:
          Icons.home_rounded, // TODO: replace with custom Inicio filled icon
    ),
    const StylaBottomNavItem(
      label: 'Closet',
      icon: Icons.storefront_outlined, // TODO: replace with Closet icon asset
      activeIcon: Icons.storefront, // TODO: replace with Closet icon asset
    ),
    const StylaBottomNavItem(
      label: 'Vestirse',
      icon:
          Icons.auto_awesome_outlined, // TODO: replace with Vestirse icon asset
      activeIcon: Icons.auto_awesome, // TODO: replace with Vestirse icon asset
    ),
    const StylaBottomNavItem(
      label: 'Comunidad',
      icon: Icons.public_outlined, // TODO: replace with Comunidad icon asset
      activeIcon: Icons.public, // TODO: replace with Comunidad icon asset
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
