import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';

class TagSelectorSection extends StatelessWidget {
  final List<Tag> availableTags;
  final Set<String> selectedTagIds;
  final Function(String) onTagToggled;

  const TagSelectorSection({
    super.key,
    required this.availableTags,
    required this.selectedTagIds,
    required this.onTagToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags (opcional)',
          style: AppTypography.subtitle.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.borderRadiusLarge,
          ),
          child: availableTags.isEmpty
              ? Text(
                  'No hay tags disponibles',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableTags.map((tag) {
                    final isSelected = selectedTagIds.contains(tag.id);
                    return FilterChip(
                      label: Text(tag.name),
                      selected: isSelected,
                      onSelected: (_) => onTagToggled(tag.id),
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.black,
                      labelStyle: AppTypography.body.copyWith(
                        color: isSelected
                            ? Colors.black
                            : AppColors.textPrimary,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
