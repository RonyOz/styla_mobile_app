import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

/// Styled bottom navigation bar that matches the Styla visual language.
class StylaBottomNavigationBar extends StatelessWidget {
  const StylaBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.backgroundColor = AppColors.border,
    this.selectedColor = AppColors.primary,
    this.unselectedColor = AppColors.secondaryLightest,
  });

  final List<StylaBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, -4),
                blurRadius: 12,
              ),
            ],
          ),
          child: ClipRRect(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: currentIndex,
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTypography.caption,
              onTap: onTap,
              items: [
                for (final item in items)
                  BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    activeIcon: Icon(item.activeIcon),
                    label: item.label,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StylaBottomNavItem {
  const StylaBottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
