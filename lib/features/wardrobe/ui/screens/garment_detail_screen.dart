import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/occasion_option.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/garment_image_header.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/category_chips_section.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/editable_tags_section.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/garment_attribute_field.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/ai_recommendations_section.dart';

class GarmentDetailScreen extends StatefulWidget {
  final Garment garment;

  const GarmentDetailScreen({super.key, required this.garment});

  @override
  State<GarmentDetailScreen> createState() => _GarmentDetailScreenState();
}

class _GarmentDetailScreenState extends State<GarmentDetailScreen> {
  final ImagePicker _picker = ImagePicker();

  // State
  String? _selectedImagePath;
  List<Category> _categories = [];
  List<Tag> _availableTags = [];
  List<ColorOption> _colors = [];
  List<StyleOption> _styles = [];
  List<OccasionOption> _occasions = [];

  String? _selectedCategoryId;
  List<String> _selectedTagNames = [];
  String? _selectedColor;
  String? _selectedStyle;
  String? _selectedOccasion;

  @override
  void initState() {
    super.initState();

    // Inicializar valores actuales
    _selectedColor = widget.garment.color;
    _selectedStyle = widget.garment.style;
    _selectedOccasion = widget.garment.occasion;
    _selectedTagNames = widget.garment.tagNames?.toList() ?? [];

    // Cargar datos necesarios
    context.read<WardrobeBloc>().add(LoadCategoriesRequested());
    context.read<WardrobeBloc>().add(LoadTagsRequested());
    context.read<WardrobeBloc>().add(LoadColorsRequested());
    context.read<WardrobeBloc>().add(LoadStylesRequested());
    context.read<WardrobeBloc>().add(LoadOccasionsRequested());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });

      if (mounted) {
        context.read<WardrobeBloc>().add(
          UpdateGarmentImageRequested(
            garmentId: widget.garment.id,
            newImagePath: image.path,
          ),
        );
      }
    }
  }

  void _updateField(String field, String value) {
    context.read<WardrobeBloc>().add(
      UpdateGarmentFieldRequested(
        garmentId: widget.garment.id,
        field: field,
        value: value,
      ),
    );
  }

  void _updateTags() {
    // Obtener IDs de las tags seleccionadas
    final tagIds = _availableTags
        .where((tag) => _selectedTagNames.contains(tag.name))
        .map((tag) => tag.id)
        .toList();

    context.read<WardrobeBloc>().add(
      UpdateGarmentTagsRequested(garmentId: widget.garment.id, tagIds: tagIds),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Eliminar prenda',
          style: AppTypography.subtitle.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar esta prenda?',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Cerrar diálogo
              context.read<WardrobeBloc>().add(
                DeleteGarmentRequested(garmentId: widget.garment.id),
              );
              // NO cerrar la pantalla aquí, esperar al listener
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showAddTagDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Seleccionar etiquetas',
            style: AppTypography.subtitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTagNames.contains(tag.name);
                return CheckboxListTile(
                  title: Text(
                    tag.name,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  value: isSelected,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedTagNames.add(tag.name);
                      } else {
                        _selectedTagNames.remove(tag.name);
                      }
                    });
                    Navigator.pop(context);
                    _updateTags();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WardrobeBloc, WardrobeState>(
      listener: (context, state) {
        if (state is CategoriesLoadedState) {
          setState(() {
            _categories = state.categories;
            final currentCategory = state.categories.firstWhere(
              (cat) => cat.name == widget.garment.categoryName,
              orElse: () => state.categories.first,
            );
            _selectedCategoryId = currentCategory.id;
          });
        } else if (state is TagsLoadedState) {
          setState(() {
            _availableTags = state.tags;
          });
        } else if (state is ColorsLoadedState) {
          setState(() {
            _colors = state.colors;
            // Validar que el color seleccionado existe en la lista
            final colorNames = _colors.map((c) => c.name).toList();
            if (_selectedColor != null &&
                !colorNames.contains(_selectedColor)) {
              _selectedColor = null; // Limpiar si no existe
            }
          });
        } else if (state is StylesLoadedState) {
          setState(() {
            _styles = state.styles;
            // Validar que el estilo seleccionado existe en la lista
            final styleNames = _styles.map((s) => s.name).toList();
            if (_selectedStyle != null &&
                !styleNames.contains(_selectedStyle)) {
              _selectedStyle = null; // Limpiar si no existe
            }
          });
        } else if (state is OccasionsLoadedState) {
          setState(() {
            _occasions = state.occasions;
            // Validar que la ocasión seleccionada existe en la lista
            final occasionNames = _occasions.map((o) => o.name).toList();
            if (_selectedOccasion != null &&
                !occasionNames.contains(_selectedOccasion)) {
              _selectedOccasion = null; // Limpiar si no existe
            }
          });
        } else if (state is GarmentUpdatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prenda actualizada'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is GarmentDeletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prenda eliminada'),
              backgroundColor: AppColors.success,
            ),
          );
          // Cerrar la pantalla después de eliminar
          Navigator.of(context).pop();
        } else if (state is WardrobeErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // AppBar con imagen
            GarmentImageHeader(
              imageUrl: widget.garment.imageUrl,
              localImagePath: _selectedImagePath,
              onEditImage: _pickImage,
              onBack: () => Navigator.of(context).pop(),
              onMoreOptions: _showDeleteConfirmation,
            ),

            // Contenido
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chips de categoría
                    CategoryChipsSection(
                      categories: _categories,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        setState(() {
                          _selectedCategoryId = categoryId;
                        });
                        context.read<WardrobeBloc>().add(
                          UpdateGarmentCategoryRequested(
                            garmentId: widget.garment.id,
                            categoryId: categoryId,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Etiquetas editables
                    EditableTagsSection(
                      selectedTags: _selectedTagNames,
                      onAddTag: _showAddTagDialog,
                      onRemoveTag: (tagName) {
                        setState(() {
                          _selectedTagNames.remove(tagName);
                        });
                        _updateTags();
                      },
                    ),

                    const SizedBox(height: 24),

                    // Campo Color
                    GarmentAttributeField(
                      label: 'Color',
                      value: _selectedColor,
                      items: _colors.map((c) => c.name).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedColor = value);
                          _updateField('color', value);
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Campo Estilo
                    GarmentAttributeField(
                      label: 'Estilo',
                      value: _selectedStyle,
                      items: _styles.map((s) => s.name).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedStyle = value);
                          _updateField('style', value);
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Campo Ocasión
                    GarmentAttributeField(
                      label: 'Ocasión',
                      value: _selectedOccasion,
                      items: _occasions.map((o) => o.name).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedOccasion = value);
                          _updateField('occasion', value);
                        }
                      },
                    ),

                    const SizedBox(height: 32),

                    // Sección de Recomendaciones IA
                    const AIRecommendationsSection(),

                    const SizedBox(height: 20),

                    // Mensaje de IA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: AppRadius.borderRadiusLarge,
                        border: Border.all(
                          color: AppColors.secondary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'AQUÍ se renderizarán las prendas con IA',
                        style: AppTypography.body.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
