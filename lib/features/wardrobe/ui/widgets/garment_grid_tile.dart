import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/core/domain/model/garment.dart';

class GarmentGridTile extends StatelessWidget {
  const GarmentGridTile({
    super.key,
    required this.garment,
    required this.onTap,
  });

  final Garment garment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tags = garment.tagNames ?? const [];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned.fill(
                child: garment.imageUrl.isNotEmpty
                    ? Image.network(
                        garment.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const GarmentPlaceholder(),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const GarmentPlaceholder(isLoading: true);
                        },
                      )
                    : const GarmentPlaceholder(),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.45),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        garment.categoryName?.isNotEmpty == true
                            ? garment.categoryName!
                            : 'Sin categoria',
                        style: AppTypography.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (tags.isNotEmpty)
                        Text(
                          tags.take(2).join(' / '),
                          style: AppTypography.caption.copyWith(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GarmentPlaceholder extends StatelessWidget {
  const GarmentPlaceholder({super.key, this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : Icon(
                Icons.checkroom_outlined,
                size: 36,
                color: Colors.white.withOpacity(0.4),
              ),
      ),
    );
  }
}
