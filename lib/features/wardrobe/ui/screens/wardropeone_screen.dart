import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';

class GarmentDetailScreen extends StatelessWidget {
  final String garmentId;

  const GarmentDetailScreen({Key? key, required this.garmentId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          context.read<WardrobeBloc>()
            ..add(GetGarmentByIdRequested(garmentId: garmentId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Mi closet',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_border, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.apps, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<WardrobeBloc, WardrobeState>(
          builder: (context, state) {
            if (state is WardrobeLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state is WardrobeErrorState) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is WardrobeLoadedOneState) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFD4A574), Color(0xFF8B6F47)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Center(
                              child: state.garment.imageUrl != null
                                  ? Image.network(
                                      state.garment.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return _buildPlaceholderGarment();
                                          },
                                    )
                                  : _buildPlaceholderGarment(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildCategoryButton(
                            context,
                            state.garment.tagNames?.isNotEmpty == true
                                ? state.garment.tagNames!.first
                                : 'Sin tag',
                            true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCategoryButton(
                            context,
                            state.garment.categoryName ?? 'Sin categoría',
                            true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCategoryButton(
                            context,
                            state.garment.color ?? 'Sin color',
                            true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderGarment() {
    return Container(
      padding: const EdgeInsets.all(1),
      child: Image.asset(
        'assets/images/placeholder_garment.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.checkroom, size: 120, color: Colors.white70);
        },
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String label,
    bool isSelected,
  ) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.white54,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            // Acción al presionar el botón
          },
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
