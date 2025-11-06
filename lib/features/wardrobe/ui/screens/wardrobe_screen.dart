import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/add_garment_screen.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/garment_detail_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  bool _showFilters = false;
  String? _selectedCategory;
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    context.read<WardrobeBloc>().add(LoadGarmentsRequested());
  }

  void _applyFilters() {
    context.read<WardrobeBloc>().add(
      GetFilteredGarmentsRequested(
        category: _selectedCategory ?? '',
        tags: _selectedTags,
      ),
    );
    setState(() {
      _showFilters = false;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedTags.clear();
    });
    context.read<WardrobeBloc>().add(LoadGarmentsRequested());
  }

  void _showGarmentDetail(BuildContext context, dynamic garment) {
    // Capturar el BLoC antes de abrir la pantalla
    final wardrobeBloc = context.read<WardrobeBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: wardrobeBloc,
          child: GarmentDetailScreen(garment: garment),
        ),
      ),
    ).then((_) {
      // Recargar prendas cuando se regresa de la pantalla de detalles
      context.read<WardrobeBloc>().add(LoadGarmentsRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Guardarropa'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: (_selectedCategory != null || _selectedTags.isNotEmpty)
                  ? AppColors.primary
                  : null,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<WardrobeBloc>(),
                    child: const AddGarmentScreen(),
                  ),
                ),
              ).then((_) {
                // Recargar prendas cuando se regresa de la pantalla de agregar
                context.read<WardrobeBloc>().add(LoadGarmentsRequested());
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilterSection(),
          Expanded(
            child: BlocBuilder<WardrobeBloc, WardrobeState>(
              builder: (context, state) {
                if (state is WardrobeLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is WardrobeErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        AppSpacing.verticalMedium,
                        Text(
                          state.message,
                          style: AppTypography.body.copyWith(
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state is WardrobeLoadedState) {
                  if (state.garments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.checkroom,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          AppSpacing.verticalMedium,
                          Text(
                            'No tienes prendas aún',
                            style: AppTypography.subtitle.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          AppSpacing.verticalSmall,
                          Text(
                            'Agrega tu primera prenda',
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: AppSpacing.paddingMedium,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: state.garments.length,
                    itemBuilder: (context, index) {
                      final garment = state.garments[index];
                      return InkWell(
                        onTap: () => _showGarmentDetail(context, garment),
                        borderRadius: BorderRadius.circular(12),
                        child: Card(
                          color: AppColors.surface,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      garment.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.checkroom,
                                              size: 48,
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: AppSpacing.paddingSmall,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      garment.categoryName ?? '',
                                      style: AppTypography.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (garment.tagNames?.isNotEmpty ?? false)
                                      Text(
                                        garment.tagNames?.join(', ') ?? '',
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    // Aquí debes definir las categorías y tags disponibles
    // Idealmente vendrían de un repositorio o estado
    final categories = ['Prendas Superiores', 'Calzado', 'Prendas Inferiores'];

    final tags = ['Old Money', 'emo', 'oversized', 'Street wear', 'Fresco'];

    return Container(
      padding: AppSpacing.paddingMedium,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros',
                style: AppTypography.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: Text(
                  'Limpiar',
                  style: AppTypography.body.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          AppSpacing.verticalSmall,
          Text(
            'Categoría',
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.verticalSmall,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = _selectedCategory == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          AppSpacing.verticalMedium,
          Text(
            'Etiquetas',
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.verticalSmall,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          AppSpacing.verticalMedium,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Aplicar filtros',
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
