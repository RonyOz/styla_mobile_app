import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';

// TODO: fixear diseño. Que el usuario pueda agregar sus propios tags.
class AddGarmentScreen extends StatefulWidget {
  const AddGarmentScreen({super.key});

  @override
  State<AddGarmentScreen> createState() => _AddGarmentScreenState();
}

class _AddGarmentScreenState extends State<AddGarmentScreen> {
  String? _selectedImagePath;
  Category? _selectedCategory;
  final Set<String> _selectedTagIds = {};
  
  // Nuevos campos
  String _selectedColor = 'Negro';
  String _selectedStyle = 'Casual';
  String _selectedOccasion = 'Diario';

  List<Category> _categories = [];
  List<Tag> _availableTags = [];
  bool _isLoadingData = true;

  // Opciones predefinidas
  final List<String> _colors = [
    'Negro',
    'Blanco',
    'Gris',
    'Azul',
    'Rojo',
    'Verde',
    'Amarillo',
    'Naranja',
    'Rosa',
    'Morado',
    'Café',
    'Beige',
  ];

  final List<String> _styles = [
    'Casual',
    'Formal',
    'Deportivo',
    'Elegante',
    'Vintage',
    'Moderno',
    'Clásico',
  ];

  final List<String> _occasions = [
    'Diario',
    'Trabajo',
    'Fiesta',
    'Deporte',
    'Viaje',
    'Especial',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Cargar categorías y tags al iniciar
    context.read<WardrobeBloc>().add(LoadCategoriesRequested());
    context.read<WardrobeBloc>().add(LoadTagsRequested());
  }

  void _pickImage() {
    // TODO: Implementar selección de imagen
    // Usar image_picker package
    setState(() {
      _selectedImagePath = '/path/to/image.jpg'; // Temporal
    });
  }

  void _handleAddGarment() {
    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una imagen')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una categoría')),
      );
      return;
    }

    context.read<WardrobeBloc>().add(
          AddGarmentRequested(
            imagePath: _selectedImagePath!,
            categoryId: _selectedCategory!.id,
            tagIds: _selectedTagIds.toList(),
            color: _selectedColor,
            style: _selectedStyle,
            occasion: _selectedOccasion,
          ),
        );
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (_selectedTagIds.contains(tagId)) {
        _selectedTagIds.remove(tagId);
      } else {
        _selectedTagIds.add(tagId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Agregar Prenda'),
        backgroundColor: AppColors.background,
      ),
      body: BlocListener<WardrobeBloc, WardrobeState>(
        listener: (context, state) {
          if (state is CategoriesLoadedState) {
            setState(() {
              _categories = state.categories;
              if (_categories.isNotEmpty) {
                _selectedCategory = _categories.first;
              }
            });
          } else if (state is TagsLoadedState) {
            setState(() {
              _availableTags = state.tags;
              _isLoadingData = false;
            });
          } else if (state is GarmentAddedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Prenda agregada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is WardrobeErrorState) {
            setState(() {
              _isLoadingData = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: _isLoadingData
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
            padding: AppSpacing.paddingLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Selecciona una foto de tu prenda',
                  style: AppTypography.title.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalLarge,
                
                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: _selectedImagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 64,
                                color: AppColors.primary,
                              ),
                              AppSpacing.verticalSmall,
                              Text(
                                'Toca para seleccionar',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              'Imagen seleccionada',
                              style: AppTypography.body,
                            ),
                          ),
                  ),
                ),
                AppSpacing.verticalLarge,

                // Category Selector
                Text(
                  'Categoría',
                  style: AppTypography.subtitle,
                ),
                AppSpacing.verticalSmall,
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: AppColors.surface,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name,
                        style: AppTypography.body,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                AppSpacing.verticalLarge,

                // Color Selector
                Text(
                  'Color',
                  style: AppTypography.subtitle,
                ),
                AppSpacing.verticalSmall,
                DropdownButtonFormField<String>(
                  value: _selectedColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: AppColors.surface,
                  items: _colors.map((color) {
                    return DropdownMenuItem(
                      value: color,
                      child: Text(
                        color,
                        style: AppTypography.body,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedColor = value;
                      });
                    }
                  },
                ),
                AppSpacing.verticalLarge,

                // Style Selector
                Text(
                  'Estilo',
                  style: AppTypography.subtitle,
                ),
                AppSpacing.verticalSmall,
                DropdownButtonFormField<String>(
                  value: _selectedStyle,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: AppColors.surface,
                  items: _styles.map((style) {
                    return DropdownMenuItem(
                      value: style,
                      child: Text(
                        style,
                        style: AppTypography.body,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStyle = value;
                      });
                    }
                  },
                ),
                AppSpacing.verticalLarge,

                // Occasion Selector
                Text(
                  'Ocasión',
                  style: AppTypography.subtitle,
                ),
                AppSpacing.verticalSmall,
                DropdownButtonFormField<String>(
                  value: _selectedOccasion,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: AppColors.surface,
                  items: _occasions.map((occasion) {
                    return DropdownMenuItem(
                      value: occasion,
                      child: Text(
                        occasion,
                        style: AppTypography.body,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedOccasion = value;
                      });
                    }
                  },
                ),
                AppSpacing.verticalLarge,

                // Tags Selector
                Text(
                  'Tags (opcional)',
                  style: AppTypography.subtitle,
                ),
                AppSpacing.verticalSmall,
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _availableTags.isEmpty
                      ? Text(
                          'No hay tags disponibles',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableTags.map((tag) {
                            final isSelected = _selectedTagIds.contains(tag.id);
                            return FilterChip(
                              label: Text(tag.name),
                              selected: isSelected,
                              onSelected: (_) => _toggleTag(tag.id),
                              backgroundColor: AppColors.surface,
                              selectedColor: AppColors.primary.withOpacity(0.2),
                              checkmarkColor: AppColors.primary,
                              labelStyle: AppTypography.body.copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            );
                          }).toList(),
                        ),
                ),
                const Spacer(),

                // Add Button
                BlocBuilder<WardrobeBloc, WardrobeState>(
                  builder: (context, state) {
                    final isLoading = state is WardrobeLoadingState;
                    return AppButton.primary(
                      text: 'Agregar Prenda',
                      onPressed: isLoading ? null : _handleAddGarment,
                      isLoading: isLoading,
                    );
                  },
                ),
                AppSpacing.verticalLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
