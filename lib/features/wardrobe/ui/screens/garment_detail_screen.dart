import 'dart:io';
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
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              context.read<WardrobeBloc>().add(
                DeleteGarmentRequested(garmentId: widget.garment.id),
              );
              Navigator.pop(context); // Cerrar pantalla
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
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.background,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _showDeleteConfirmation,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Imagen de la prenda
                    _selectedImagePath != null
                        ? Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.cover,
                          )
                        : widget.garment.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.garment.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.surfaceVariant,
                                child: const Icon(
                                  Icons.checkroom,
                                  size: 80,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.surfaceVariant,
                            child: const Icon(
                              Icons.checkroom,
                              size: 80,
                              color: AppColors.textSecondary,
                            ),
                          ),
                    // Overlay gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Botón de cambiar imagen
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton.small(
                        onPressed: _pickImage,
                        backgroundColor: AppColors.primary,
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                    // Texto "Mi closet"
                    Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Mi closet',
                          style: AppTypography.subtitle.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contenido
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chips de categoría
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategoryId == category.id;
                        return ChoiceChip(
                          label: Text(category.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategoryId = category.id;
                              });
                              context.read<WardrobeBloc>().add(
                                UpdateGarmentCategoryRequested(
                                  garmentId: widget.garment.id,
                                  categoryId: category.id,
                                ),
                              );
                            }
                          },
                          backgroundColor: AppColors.surface,
                          selectedColor: AppColors.secondaryLightest,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.textOnSecondary
                                : AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Etiquetas editables
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Etiquetas',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          color: AppColors.primary,
                          onPressed: _showAddTagDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedTagNames.map((tagName) {
                        return InputChip(
                          label: Text(tagName),
                          onDeleted: () {
                            setState(() {
                              _selectedTagNames.remove(tagName);
                            });
                            _updateTags();
                          },
                          deleteIconColor: AppColors.textOnSecondary,
                          backgroundColor: AppColors.secondaryLightest,
                          labelStyle: AppTypography.body.copyWith(
                            color: AppColors.textOnSecondary,
                            fontSize: 14,
                          ),
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Campo Color
                    _buildDropdownField(
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
                    _buildDropdownField(
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
                    _buildDropdownField(
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
                    Row(
                      children: [
                        Text(
                          'Recomendaciones de StyleIA',
                          style: AppTypography.subtitle.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.auto_awesome,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grid de outfits (placeholders)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: List.generate(4, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.checkroom_outlined,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // Mensaje de IA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          dropdownColor: AppColors.surfaceVariant,
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required Function(String) onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check, size: 20),
              color: AppColors.primary,
              onPressed: () {
                onSubmitted(controller.text);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
