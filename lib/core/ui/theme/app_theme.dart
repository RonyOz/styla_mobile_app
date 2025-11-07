import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_typography.dart';
import '../design/app_spacing.dart';

/// Tema básico de la aplicación
class AppTheme {
  AppTheme._();

  /// Tema oscuro de la aplicación
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.subtitle.copyWith(
          color: AppColors.textPrimary,
        ),
      ),

      // Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          textStyle: AppTypography.button,
          padding: AppSpacing.paddingMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          textStyle: AppTypography.button,
          padding: AppSpacing.paddingMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        headlineLarge: AppTypography.title.copyWith(color: AppColors.textPrimary),
        headlineMedium: AppTypography.subtitle.copyWith(color: AppColors.textPrimary),
        bodyLarge: AppTypography.body.copyWith(color: AppColors.textPrimary),
        bodyMedium: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        labelLarge: AppTypography.button,
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: AppSpacing.paddingMedium,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: AppColors.grey),
      ),

      // Card theme
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: AppColors.textSecondary,
      ),

      // Divider
      dividerColor: AppColors.border,
    );
  }
}
