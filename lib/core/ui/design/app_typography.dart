import 'package:flutter/material.dart';

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
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: headingFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle button = TextStyle(
    fontFamily: headingFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}