import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImageSourceBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImageSourceBottomSheet(
        onCameraTap: onCameraTap,
        onGalleryTap: onGalleryTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.paddingMedium,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Seleccionar imagen',
              style: AppTypography.title.copyWith(color: AppColors.primary),
            ),
            AppSpacing.verticalMedium,
            ListTile(
              leading: const Icon(Icons.camera_alt, size: 32),
              title: Text('Cámara', style: AppTypography.body),
              onTap: () {
                Navigator.pop(context);
                onCameraTap();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, size: 32),
              title: Text('Galería', style: AppTypography.body),
              onTap: () {
                Navigator.pop(context);
                onGalleryTap();
              },
            ),
            AppSpacing.verticalSmall,
          ],
        ),
      ),
    );
  }
}
