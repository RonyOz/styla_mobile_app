import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';

class WardrobeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const WardrobeErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTypography.body.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
