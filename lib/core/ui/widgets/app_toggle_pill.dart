import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_radius.dart';

/// Toggle pill genérico para selección entre dos opciones
/// 
/// Estándar de diseño:
/// - borderRadius: AppRadius.medium (10)
/// - padding interno: 4
/// - itemPadding: 12h x 8v
/// - iconSize: 18
class AppTogglePill<T> extends StatelessWidget {
  final T selected;
  final ValueChanged<T> onChanged;
  final List<AppToggleOption<T>> options;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? itemPadding;
  final double? iconSize;
  final double borderRadius;

  const AppTogglePill({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.options,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.padding,
    this.itemPadding,
    this.iconSize,
    this.borderRadius = AppRadius.medium,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.secondary;
    final effectiveInactiveColor = inactiveColor ?? AppColors.textPrimary;
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surfaceVariant;
    final effectivePadding = padding ?? const EdgeInsets.all(4);
    final effectiveItemPadding = itemPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    final effectiveIconSize = iconSize ?? 18;

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = selected == option.value;
          return _ToggleButton(
            icon: option.icon,
            isSelected: isSelected,
            onTap: () => onChanged(option.value),
            activeColor: effectiveActiveColor,
            inactiveColor: effectiveInactiveColor,
            padding: effectiveItemPadding,
            iconSize: effectiveIconSize,
            borderRadius: borderRadius,
          );
        }).toList(),
      ),
    );
  }
}

/// Opción para el toggle pill
class AppToggleOption<T> {
  final T value;
  final IconData icon;
  final String? label;

  const AppToggleOption({
    required this.value,
    required this.icon,
    this.label,
  });
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.padding,
    required this.iconSize,
    required this.borderRadius,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsets padding;
  final double iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: isSelected ? AppColors.textOnSecondary : inactiveColor,
        ),
      ),
    );
  }
}
