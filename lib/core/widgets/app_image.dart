import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

/// Widget para mostrar logos de la aplicación
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final LogoType type;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.type = LogoType.main,
  });

  /// Logo principal (para pantallas normales)
  const AppLogo.main({
    super.key,
    this.width,
    this.height,
  }) : type = LogoType.main;

  /// Logo blanco (para fondos oscuros)
  const AppLogo.white({
    super.key,
    this.width,
    this.height,
  }) : type = LogoType.white;

  /// Solo el icono (versión compacta)
  const AppLogo.icon({
    super.key,
    this.width,
    this.height,
  }) : type = LogoType.icon;

  /// Logo para splash screen
  const AppLogo.splash({
    super.key,
    this.width,
    this.height,
  }) : type = LogoType.splash;

  @override
  Widget build(BuildContext context) {
    final String assetPath = switch (type) {
      LogoType.main => AppAssets.logoMain,
      LogoType.white => AppAssets.logoWhite,
      LogoType.icon => AppAssets.logoIcon,
      LogoType.splash => AppAssets.logoSplash,
    };

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        // Fallback si no existe la imagen
        return Container(
          width: width ?? 100,
          height: height ?? 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.image_not_supported,
            size: (width ?? 100) * 0.4,
            color: Colors.grey.shade600,
          ),
        );
      },
    );
  }
}

/// Tipos de logo disponibles
enum LogoType {
  main,
  white,
  icon,
  splash,
}

/// Widget para mostrar imágenes de la aplicación
class AppImage extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;

  const AppImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return placeholder ??
            Container(
              width: width ?? 100,
              height: height ?? 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image_not_supported,
                size: (width ?? 100) * 0.4,
                color: Colors.grey.shade600,
              ),
            );
      },
    );
  }
}