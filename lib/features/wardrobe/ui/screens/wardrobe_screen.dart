import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/add_garment_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String? _selectedCategory;
  final List<String> _selectedTags = [];

  // Lista de categorías disponibles
  final List<String> _categories = [
    'Camisas',
    'Pantalones',
    'Gorras',
    'Zapatos',
    'Chaquetas',
    'Vestidos',
  ];

  // Lista de tags disponibles
  final List<String> _availableTags = [
    'Casual',
    'Formal',
    'Deportivo',
    'Elegante',
    'Verano',
    'Invierno',
  ];

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
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedTags.clear();
    });
    context.read<WardrobeBloc>().add(LoadGarmentsRequested());
    Navigator.pop(context);
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Filtros', style: AppTypography.subtitle)],
                  ),
                  AppSpacing.verticalMedium,
                  Text(
                    'Categoría',
                    style: AppTypography.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalSmall,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          });
                        },
                        backgroundColor: AppColors.background,
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                      );
                    }).toList(),
                  ),
                  AppSpacing.verticalMedium,
                  Text(
                    'Etiquetas',
                    style: AppTypography.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalSmall,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          });
                        },
                        backgroundColor: AppColors.background,
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                      );
                    }).toList(),
                  ),
                  AppSpacing.verticalLarge,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _clearFilters,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters =
        _selectedCategory != null || _selectedTags.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Guardarropa'),
        backgroundColor: AppColors.background,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddGarmentScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (hasActiveFilters)
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMedium,
              color: AppColors.surface,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_selectedCategory != null)
                    Chip(
                      label: Text(_selectedCategory!),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                    ),
                  ..._selectedTags.map(
                    (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
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
                            hasActiveFilters
                                ? 'No se encontraron prendas'
                                : 'No tienes prendas aún',
                            style: AppTypography.subtitle.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          AppSpacing.verticalSmall,
                          Text(
                            hasActiveFilters
                                ? 'Intenta con otros filtros'
                                : 'Agrega tu primera prenda',
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
                      return Card(
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
                                child: const Icon(Icons.checkroom, size: 48),
                              ),
                            ),
                            Padding(
                              padding: AppSpacing.paddingSmall,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    garment.categoryName,
                                    style: AppTypography.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (garment.tagNames.isNotEmpty)
                                    Text(
                                      garment.tagNames.join(', '),
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
}
