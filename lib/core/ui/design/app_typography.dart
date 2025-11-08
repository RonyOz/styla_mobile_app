import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/ui/design/app_colors.dart';

/// Tipografía básica de la aplicación
class AppTypography {
  AppTypography._();

  // Fuentes - cambia aquí para usar otras fuentes
  static const String headingFont = 'Akatab';    // Para títulos
  static const String bodyFont = 'Albert Sans';        // Para texto general

  // Estilos básicos
  static const TextStyle title = TextStyle(
    fontFamily: headingFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: headingFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}