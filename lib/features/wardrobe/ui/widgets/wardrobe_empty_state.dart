import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class WardrobeEmptyState extends StatelessWidget {
  final VoidCallback onAddGarment;

  const WardrobeEmptyState({
    super.key,
    required this.onAddGarment,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        key: const ValueKey('wardrobe_empty'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checkroom_outlined, size: 82, color: AppColors.secondary),
          const SizedBox(height: 24),
          Text(
            'Aun no tienes nada agregado',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.secondary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega algo para empezar',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: onAddGarment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text('Agregar ropa'),
            ),
          ),
        ],
      ),
    );
  }
}
