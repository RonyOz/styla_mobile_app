import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/dress/ui/screens/outfit_detail_screen.dart';

class AIRecommendationsSection extends StatelessWidget {
  final List<Outfit> outfits;
  final bool isLoading;
  final String? errorMessage;

  const AIRecommendationsSection({
    super.key,
    required this.outfits,
    this.isLoading = false,
    this.errorMessage,
  });

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
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
          ],
        ),
        const SizedBox(height: 16),

        // Grid de outfits
        if (isLoading)
          SizedBox(
            height: 200,
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (errorMessage != null)
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              'Error: $errorMessage',
              style: AppTypography.body.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          )
        else if (outfits.isEmpty)
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
          )
        else
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: outfits.length > 4 ? 4 : outfits.length,
            itemBuilder: (context, index) {
              final outfit = outfits[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OutfitDetailScreen(outfit: outfit),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: AppRadius.borderRadiusLarge,
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.borderRadiusLarge,
                    child: Image.network(
                      outfit
                          .imageUrl, // Cambia a outfit.image_url si tu modelo usa snake_case
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.checkroom_outlined,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}
