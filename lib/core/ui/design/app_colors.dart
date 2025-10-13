import 'package:flutter/material.dart';

/// Colores para modo oscuro de la aplicación
class AppColors {
  AppColors._();

  // Color principal
  static const Color primary = Color.fromARGB(255, 237, 242, 94);
  static const Color secondary = Color.fromARGB(255, 161, 148, 242);
  static const Color secondaryLight = Color.fromARGB(255, 198, 191, 247);
  
  // Colores de fondo
  static const Color background = Color.fromARGB(255, 33, 33, 33);
  static const Color surface = Color(0x44444444);
  static const Color surfaceVariant = Color(0xFF2D2D2D);
  
  // Colores de texto
  static const Color textPrimary = Color(0xF2F2F2F2);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textOnPrimary = Color(0xFF1A1A1A);
  
  // Colores de borde
  static const Color border = Color(0xFF404040);
  static const Color borderFocus = primary;
  
  // Estados
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
  
  // Colores básicos
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
}