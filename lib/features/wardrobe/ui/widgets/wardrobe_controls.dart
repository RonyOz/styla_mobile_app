import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/wardrobe_screen.dart';

class WardrobeControls extends StatelessWidget {
  final bool hasActiveFilters;
  final bool showFilters;
  final VoidCallback onFiltersTap;
  final VoidCallback onSortTap;
  final ViewMode viewMode;
  final ValueChanged<ViewMode> onViewModeChanged;

  const WardrobeControls({
    super.key,
    required this.hasActiveFilters,
    required this.showFilters,
    required this.onFiltersTap,
    required this.onSortTap,
    required this.viewMode,
    required this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WardrobeFilterChip(
          label: 'Filtros',
          icon: Icons.filter_list,
          isActive: hasActiveFilters || showFilters,
          onTap: onFiltersTap,
        ),
        const SizedBox(width: 12),
        WardrobeFilterChip(
          label: 'Ordenar por',
          icon: Icons.swap_vert,
          onTap: onSortTap,
        ),
        const Spacer(),
        ViewTogglePill(
          selected: viewMode,
          onChanged: onViewModeChanged,
        ),
      ],
    );
  }
}

class WardrobeFilterChip extends StatelessWidget {
  const WardrobeFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondary.withOpacity(0.18)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive
                ? AppColors.secondary
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewTogglePill extends StatelessWidget {
  const ViewTogglePill({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ViewMode selected;
  final ValueChanged<ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          _ViewToggleButton(
            icon: Icons.grid_view,
            isSelected: selected == ViewMode.grid,
            onTap: () => onChanged(ViewMode.grid),
          ),
          _ViewToggleButton(
            icon: Icons.view_list,
            isSelected: selected == ViewMode.list,
            onTap: () => onChanged(ViewMode.list),
          ),
        ],
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  const _ViewToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? AppColors.textOnSecondary : Colors.white,
        ),
      ),
    );
  }
}
