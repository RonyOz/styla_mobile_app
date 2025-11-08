import 'package:flutter/material.dart';

/// Border radius constants para toda la aplicación
class AppRadius {
  AppRadius._();

  // Valores de border radius
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 18.0;
  static const double pill = 999.0;

  // BorderRadius predefinidos
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(small));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(large));
  static const BorderRadius borderRadiusPill = BorderRadius.all(Radius.circular(pill));

  // Radius predefinidos (para usar en Radius.circular)
  static const Radius radiusSmall = Radius.circular(small);
  static const Radius radiusMedium = Radius.circular(medium);
  static const Radius radiusLarge = Radius.circular(large);
  static const Radius radiusPill = Radius.circular(pill);
}
