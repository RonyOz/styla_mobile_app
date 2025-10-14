import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Styled bottom navigation bar that matches the Styla visual language.
class StylaBottomNavigationBar extends StatelessWidget {
  const StylaBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    this.backgroundColor = AppColors.border,
    this.selectedColor = AppColors.primary,
    this.unselectedColor = AppColors.secondaryLightest,
    this.height = 90.0,
    this.iconSize = 30.0, 

  });

  final List<StylaBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final double height;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: height,
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
                iconSize: iconSize,
                selectedLabelStyle: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: AppTypography.caption,
                onTap: onTap,
                items: [
                  for (final item in items)
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(item.icon, width: iconSize, height: iconSize),
                      activeIcon: SvgPicture.asset(item.activeIcon, width: iconSize, height: iconSize),
                      label: item.label,
                    ),
                ],
              ),
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
  final String icon;
  final String activeIcon;
}
