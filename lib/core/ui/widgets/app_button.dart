import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_typography.dart';
import '../design/app_spacing.dart';
import '../design/app_radius.dart';

/// Botón simple de la aplicación
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
  });

  /// Constructor para botón primario
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : isPrimary = true;

  /// Constructor para botón secundario
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : isPrimary = false;

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = isLoading
        ? const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : (icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(text),
                  const SizedBox(width: 8),
                  Icon(icon, size: 20),
                ],
              )
            : Text(text));

    if (isPrimary) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: AppSpacing.paddingLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMedium,
          ),
          textStyle: AppTypography.button,
        ),
        child: buttonContent,
      );
    } else {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryLight,
          side: BorderSide(color: AppColors.secondaryLight),
          padding: AppSpacing.paddingLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMedium,
          ),
          textStyle: AppTypography.button,
        ),
        child: isLoading
            ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryLight),
                ),
              )
            : buttonContent,
      );
    }
  }
}