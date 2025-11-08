import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class AIRecommendationsSection extends StatelessWidget {
  const AIRecommendationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recomendaciones de StyleIA',
              style: AppTypography.subtitle.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Grid de outfits (placeholders)
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: List.generate(4, (index) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppRadius.borderRadiusLarge,
                border: Border.all(
                  color: AppColors.border.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.checkroom_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 20),

        // Mensaje de IA
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.2),
            borderRadius: AppRadius.borderRadiusLarge,
            border: Border.all(
              color: AppColors.secondary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'AQUÍ se renderizarán las prendas con IA',
            style: AppTypography.body.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
