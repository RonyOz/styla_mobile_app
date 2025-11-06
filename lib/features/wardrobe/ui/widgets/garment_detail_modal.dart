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

class GarmentDetailModal extends StatefulWidget {
  final Garment garment;

  const GarmentDetailModal({super.key, required this.garment});

  @override
  State<GarmentDetailModal> createState() => _GarmentDetailModalState();
}

class _GarmentDetailModalState extends State<GarmentDetailModal> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  List<Category> _categories = [];
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Cargar categorías
    context.read<WardrobeBloc>().add(LoadCategoriesRequested());
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

      // Actualizar imagen
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar prenda'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta prenda?',
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
              Navigator.pop(context); // Cerrar modal
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WardrobeBloc, WardrobeState>(
      listener: (context, state) {
        if (state is CategoriesLoadedState) {
          setState(() {
            _categories = state.categories;
            // Encontrar el ID de la categoría actual por nombre
            final currentCategory = state.categories.firstWhere(
              (cat) => cat.name == widget.garment.categoryName,
              orElse: () => state.categories.first,
            );
            _selectedCategoryId = currentCategory.id;
          });
        } else if (state is GarmentUpdatedState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Prenda actualizada')));
          Navigator.pop(context); // Cerrar modal después de actualizar
        } else if (state is WardrobeErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Header con imagen de la prenda
            Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: _selectedImagePath != null
                        ? Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.cover,
                          )
                        : widget.garment.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.garment.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.checkroom,
                                  size: 80,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.checkroom,
                              size: 80,
                              color: AppColors.textSecondary,
                            ),
                          ),
                  ),
                ),

                // Botón de cerrar
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding: const EdgeInsets.all(8),
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

                // Botón de eliminar
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: _showDeleteConfirmation,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.8),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ),

                // Texto "Mi closet"
                Positioned(
                  top: 20,
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

            // Contenido con scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selector de categoría
                    Text(
                      'Categoría',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        dropdownColor: AppColors.surface,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        items: _categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category.id,
                                child: Text(category.name),
                              ),
                            )
                            .toList(),
                        onChanged: (newValue) {
                          if (newValue != null &&
                              newValue != _selectedCategoryId) {
                            setState(() {
                              _selectedCategoryId = newValue;
                            });
                            context.read<WardrobeBloc>().add(
                              UpdateGarmentCategoryRequested(
                                garmentId: widget.garment.id,
                                categoryId: newValue,
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Etiquetas (solo lectura)
                    if (widget.garment.tagNames?.isNotEmpty ?? false) ...[
                      Text(
                        'Etiquetas',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.garment.tagNames!.map((tag) {
                          return Chip(
                            label: Text(tag),
                            backgroundColor: AppColors.secondaryLightest,
                            labelStyle: AppTypography.body.copyWith(
                              color: AppColors.textOnSecondary,
                              fontSize: 14,
                            ),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Información adicional
                    if (widget.garment.color.isNotEmpty) ...[
                      Text(
                        'Color',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.garment.color,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (widget.garment.style.isNotEmpty) ...[
                      Text(
                        'Estilo',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.garment.style,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (widget.garment.occasion.isNotEmpty) ...[
                      Text(
                        'Ocasión',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.garment.occasion,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Botón de cerrar
                    SizedBox(
                      width: double.infinity,
                      child: AppButton.primary(
                        text: 'Cerrar',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
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
