import 'dart:io';
import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class GarmentImageHeader extends StatelessWidget {
  final String imageUrl;
  final String? localImagePath;
  final VoidCallback onEditImage;
  final VoidCallback onBack;
  final VoidCallback onMoreOptions;

  const GarmentImageHeader({
    super.key,
    required this.imageUrl,
    this.localImagePath,
    required this.onEditImage,
    required this.onBack,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        style: IconButton.styleFrom(
          backgroundColor: Colors.black54,
          foregroundColor: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onMoreOptions,
          style: IconButton.styleFrom(
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de la prenda
            _buildImage(),
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Botón de cambiar imagen
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton.small(
                onPressed: onEditImage,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
            // Texto "Mi closet"
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Mi closet',
                  style: AppTypography.subtitle.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (localImagePath != null) {
      return Image.file(
        File(localImagePath!),
        fit: BoxFit.cover,
      );
    }

    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.checkroom,
        size: 80,
        color: AppColors.textSecondary,
      ),
    );
  }
}
