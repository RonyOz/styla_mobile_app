import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_typography.dart';
import '../design/app_radius.dart';

/// Botón tipo chip compacto y reutilizable
/// 
/// Estándar de diseño:
/// - borderRadius: AppRadius.medium (10)
/// - padding: 10h x 7v (compacto)
/// - iconSize: 16
/// - fontSize: 12
class AppChipButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isActive;
  final bool isPrimary;
  final Color? color;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? iconSize;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double borderRadius;

  const AppChipButton({
    super.key,
    required this.label,
    this.icon,
    required this.onTap,
    this.isActive = false,
    this.isPrimary = false,
    this.color,
    this.activeColor,
    this.inactiveColor,
    this.iconColor,
    this.textColor,
    this.padding,
    this.iconSize,
    this.fontSize,
    this.fontWeight,
    this.borderRadius = AppRadius.medium,
  });

  /// Constructor para chip de filtro (estilo pill redondeado)
  const AppChipButton.filter({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  })  : isPrimary = false,
        color = null,
        activeColor = null,
        inactiveColor = null,
        iconColor = null,
        textColor = null,
        padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        iconSize = 16,
        fontSize = 12,
        fontWeight = FontWeight.w600,
        borderRadius = AppRadius.large;

  /// Constructor para botón de acción primario
  const AppChipButton.primary({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  })  : isPrimary = true,
        isActive = false,
        activeColor = null,
        inactiveColor = null,
        iconColor = null,
        textColor = null,
        padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        iconSize = 16,
        fontSize = 12,
        fontWeight = FontWeight.w600,
        borderRadius = AppRadius.medium;

  /// Constructor para botón de acción secundario
  const AppChipButton.secondary({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  })  : isPrimary = false,
        isActive = false,
        activeColor = null,
        inactiveColor = null,
        iconColor = null,
        textColor = null,
        padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        iconSize = 16,
        fontSize = 12,
        fontWeight = FontWeight.w600,
        borderRadius = AppRadius.large;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    final effectiveActiveColor = activeColor ?? AppColors.secondary;
    final effectiveInactiveColor = inactiveColor ?? AppColors.surfaceVariant;
    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 7);
    final effectiveIconSize = iconSize ?? 16;
    final effectiveFontSize = fontSize ?? 12;
    final effectiveFontWeight = fontWeight ?? FontWeight.w600;

    // Determinar colores según el estado (primary, active, normal)
    Color backgroundColor;
    Color borderColor;
    Color finalIconColor;
    Color finalTextColor;

    if (isPrimary) {
      // Botón primario destacado
      backgroundColor = effectiveColor.withOpacity(0.15);
      borderColor = effectiveColor.withOpacity(0.3);
      finalIconColor = iconColor ?? effectiveColor;
      finalTextColor = textColor ?? effectiveColor;
    } else if (isActive) {
      // Chip activo (filtros)
      backgroundColor = effectiveActiveColor.withOpacity(0.18);
      borderColor = effectiveActiveColor;
      finalIconColor = iconColor ?? AppColors.textPrimary;
      finalTextColor = textColor ?? AppColors.textPrimary;
    } else {
      // Estado normal
      backgroundColor = effectiveInactiveColor;
      borderColor = Colors.white.withOpacity(0.08);
      finalIconColor = iconColor ?? (color ?? AppColors.textPrimary);
      finalTextColor = textColor ?? AppColors.textPrimary;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: effectiveIconSize,
                  color: finalIconColor,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: finalTextColor,
                  fontWeight: effectiveFontWeight,
                  fontSize: effectiveFontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
