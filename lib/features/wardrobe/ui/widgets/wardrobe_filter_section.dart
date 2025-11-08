import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class WardrobeFilterSection extends StatelessWidget {
  final String? selectedCategory;
  final List<String> selectedTags;
  final List<String> categories;
  final List<String> tags;
  final VoidCallback onApply;
  final VoidCallback onClear;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onTagToggled;

  const WardrobeFilterSection({
    super.key,
    required this.selectedCategory,
    required this.selectedTags,
    required this.categories,
    required this.tags,
    required this.onApply,
    required this.onClear,
    required this.onCategoryChanged,
    required this.onTagToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filtros',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClear,
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Categorias',
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  onCategoryChanged(selected ? category : null);
                },
                selectedColor: AppColors.secondary.withOpacity(0.25),
                checkmarkColor: AppColors.white,
                backgroundColor: AppColors.surface,
                labelStyle: AppTypography.caption.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Etiquetas',
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) => onTagToggled(tag),
                selectedColor: AppColors.primary.withOpacity(0.25),
                checkmarkColor: AppColors.textOnPrimary,
                backgroundColor: AppColors.surface,
                labelStyle: AppTypography.caption.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Aplicar filtros'),
            ),
          ),
        ],
      ),
    );
  }
}
