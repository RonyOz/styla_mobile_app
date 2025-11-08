import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/wardrobe_screen.dart';

class WardrobeControls extends StatelessWidget {
  final bool hasActiveFilters;
  final bool showFilters;
  final VoidCallback onFiltersTap;
  final VoidCallback onAddGarmentTap;
  final VoidCallback onManageTagsTap;
  final ViewMode viewMode;
  final ValueChanged<ViewMode> onViewModeChanged;
  final int activeFiltersCount;

  const WardrobeControls({
    super.key,
    required this.hasActiveFilters,
    required this.showFilters,
    required this.onFiltersTap,
    required this.onAddGarmentTap,
    required this.onManageTagsTap,
    required this.viewMode,
    required this.onViewModeChanged,
    this.activeFiltersCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Filtros con contador
        AppChipButton.filter(
          label: hasActiveFilters ? 'Filtros ($activeFiltersCount)' : 'Filtros',
          icon: Icons.tune,
          isActive: showFilters,
          onTap: onFiltersTap,
        ),
        const Spacer(),
        // Toggle de vista
        AppTogglePill<ViewMode>(
          selected: viewMode,
          onChanged: onViewModeChanged,
          options: const [
            AppToggleOption(
              value: ViewMode.grid,
              icon: Icons.grid_view,
            ),
            AppToggleOption(
              value: ViewMode.list,
              icon: Icons.view_list,
            ),
          ],
        ),
        const SizedBox(width: 8),
        // Botón agregar
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showAddMenu(context),
            borderRadius: AppRadius.borderRadiusMedium,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: AppRadius.borderRadiusMedium,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: AppRadius.radiusLarge),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.borderRadiusSmall,
              ),
            ),
            const SizedBox(height: 20),
            _MenuOption(
              icon: Icons.add_photo_alternate_outlined,
              label: 'Agregar prenda',
              onTap: () {
                Navigator.pop(context);
                onAddGarmentTap();
              },
            ),
            _MenuOption(
              icon: Icons.label_outline,
              label: 'Gestionar tags',
              onTap: () {
                Navigator.pop(context);
                onManageTagsTap();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _MenuOption extends StatelessWidget {
  const _MenuOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

