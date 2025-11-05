import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/add_garment_screen.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/garment_detail_modal.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WardrobeBloc>().add(LoadGarmentsRequested());
  }

  void _showGarmentDetail(BuildContext context, dynamic garment) {
    // Capturar el BLoC antes de abrir el modal
    final wardrobeBloc = context.read<WardrobeBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: wardrobeBloc,
        child: GarmentDetailModal(garment: garment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header con título y acciones
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mi closet',
                    style: AppTypography.title.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                        onPressed: () {
                          // TODO: Implementar favoritos
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.grid_view_rounded,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                        onPressed: () {
                          // TODO: Implementar cambio de vista
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Contenido principal
            Expanded(
              child: BlocConsumer<WardrobeBloc, WardrobeState>(
                listener: (context, state) {
                  // Si se agregó, actualizó o eliminó una prenda, recargar la lista
                  if (state is GarmentAddedState ||
                      state is GarmentUpdatedState ||
                      state is GarmentDeletedState) {
                    context.read<WardrobeBloc>().add(LoadGarmentsRequested());
                  }
                },
                builder: (context, state) {
                  if (state is WardrobeLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (state is WardrobeErrorState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: AppTypography.body.copyWith(
                                color: AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is WardrobeLoadedState) {
                    if (state.garments.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return _buildGarmentGrid(context, state);
                  }

                  // Estado por defecto: mostrar estado vacío
                  return _buildEmptyState(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aún no tienes nada agregado',
              style: AppTypography.subtitle.copyWith(
                color: AppColors.secondaryLight,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
            Text(
              'Agrega algo para empezar',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                text: 'Agregar Ropa',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<WardrobeBloc>(),
                        child: const AddGarmentScreen(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGarmentGrid(BuildContext context, WardrobeLoadedState state) {
    return Column(
      children: [
        // Filtros y organización
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar filtros
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filtros'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar organización
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  icon: const Icon(Icons.sort, size: 18),
                  label: const Text('Organizar por'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<WardrobeBloc>(),
                        child: const AddGarmentScreen(),
                      ),
                    ),
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Grid de prendas
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: state.garments.length,
            itemBuilder: (context, index) {
              final garment = state.garments[index];
              return _buildGarmentCard(context, garment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGarmentCard(BuildContext context, dynamic garment) {
    return GestureDetector(
      onTap: () => _showGarmentDetail(context, garment),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Imagen de la prenda
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: garment.imageUrl.isNotEmpty
                  ? Image.network(
                      garment.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: Icon(
                              Icons.checkroom,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.surface,
                      child: const Center(
                        child: Icon(
                          Icons.checkroom,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
            ),

            // Indicador en la esquina inferior derecha
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
