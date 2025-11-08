import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/garment_grid_tile.dart';

class GarmentListTile extends StatelessWidget {
  const GarmentListTile({
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 92,
                height: 92,
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
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    garment.categoryName?.isNotEmpty == true
                        ? garment.categoryName!
                        : 'Sin categoria',
                    style: AppTypography.subtitle.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: tags
                          .take(3)
                          .map((tag) => _TagPill(text: tag))
                          .toList(),
                    )
                  else
                    Text(
                      'Agrega etiquetas para organizarla',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'Estilo: ${garment.style.isNotEmpty ? garment.style : '-'}   |   Ocasion: ${garment.occasion.isNotEmpty ? garment.occasion : '-'}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }
}
