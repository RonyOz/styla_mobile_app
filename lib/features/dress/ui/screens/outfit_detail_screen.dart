import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';

/// Pantalla de detalle del outfit
class OutfitDetailScreen extends StatelessWidget {
  final Outfit outfit;

  const OutfitDetailScreen({Key? key, required this.outfit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detalle del Outfit',
          style: AppTypography.subtitle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Implementar compartir
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartir próximamente')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Mostrar opciones
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: OutfitCard(
          outfit: outfit,
          showNotes: true,
          showTags: true,
          onFavoriteToggle: () {
            // TODO: Implementar toggle de favorito
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Favorito próximamente')),
            );
          },
          isFavorite: false,
        ),
      ),
    );
  }
}
