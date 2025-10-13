import 'package:flutter/material.dart';

/// Logo mínimo de la aplicación: carga directamente el asset principal.
/// Uso: const AppLogo(width: 180, height: 120)
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logos/logo_main.png',
      width: width,
      height: height,
      fit: fit,
      // Fallback mínimo: no renderiza nada si falta el asset.
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}