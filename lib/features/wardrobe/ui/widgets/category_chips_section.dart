import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';

class CategoryChipsSection extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const CategoryChipsSection({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = selectedCategoryId == category.id;
        return ChoiceChip(
          label: Text(category.name),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onCategorySelected(category.id);
            }
          },
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.secondaryLightest,
          labelStyle: TextStyle(
            color: isSelected
                ? AppColors.textOnSecondary
                : AppColors.textPrimary,
            fontSize: 14,
          ),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }
}
