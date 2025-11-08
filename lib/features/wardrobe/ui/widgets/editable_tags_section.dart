import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class EditableTagsSection extends StatelessWidget {
  final List<String> selectedTags;
  final VoidCallback onAddTag;
  final ValueChanged<String> onRemoveTag;

  const EditableTagsSection({
    super.key,
    required this.selectedTags,
    required this.onAddTag,
    required this.onRemoveTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Etiquetas',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              color: AppColors.primary,
              onPressed: onAddTag,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedTags.map((tagName) {
            return InputChip(
              label: Text(tagName),
              onDeleted: () => onRemoveTag(tagName),
              deleteIconColor: AppColors.textOnSecondary,
              backgroundColor: AppColors.secondaryLightest,
              labelStyle: AppTypography.body.copyWith(
                color: AppColors.textOnSecondary,
                fontSize: 14,
              ),
              side: BorderSide.none,
            );
          }).toList(),
        ),
      ],
    );
  }
}
