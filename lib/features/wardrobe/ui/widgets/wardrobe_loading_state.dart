import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class WardrobeLoadingView extends StatelessWidget {
  const WardrobeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const ValueKey('wardrobe_loading'),
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const _WardrobeSkeletonTile(),
    );
  }
}

class _WardrobeSkeletonTile extends StatelessWidget {
  const _WardrobeSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.borderRadiusLarge,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
