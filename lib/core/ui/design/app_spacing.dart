import 'package:flutter/material.dart';

/// Espaciados básicos de la aplicación
class AppSpacing {
  AppSpacing._();

  // Espaciados
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;

  // SizedBox predefinidos
  static const Widget verticalSmall = SizedBox(height: small);
  static const Widget verticalMedium = SizedBox(height: medium);
  static const Widget verticalLarge = SizedBox(height: large);

  static const Widget horizontalSmall = SizedBox(width: small);
  static const Widget horizontalMedium = SizedBox(width: medium);
  static const Widget horizontalLarge = SizedBox(width: large);

  // EdgeInsets predefinidos
  static const EdgeInsets paddingSmall = EdgeInsets.all(small);
  static const EdgeInsets paddingMedium = EdgeInsets.all(medium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(large);
}