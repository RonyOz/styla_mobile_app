import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/occasion_option.dart';
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
  final imgPicker =
      ImagePicker(); // TODO: va fuera del dominio, es otro datasource
  String? _selectedImagePath;

  Category? _selectedCategory;
  final Set<String> _selectedTagIds = {};

  String? _selectedColor;
  String? _selectedStyle;
  String? _selectedOccasion;

  List<Category> _categories = [];
  List<Tag> _availableTags = [];
  List<ColorOption> _colors = [];
  List<StyleOption> _styles = [];
  List<OccasionOption> _occasions = [];
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Cargar categorías, tags, colores, estilos y ocasiones al iniciar
    context.read<WardrobeBloc>().add(LoadCategoriesRequested());
    context.read<WardrobeBloc>().add(LoadTagsRequested());
    context.read<WardrobeBloc>().add(LoadColorsRequested());
    context.read<WardrobeBloc>().add(LoadStylesRequested());
    context.read<WardrobeBloc>().add(LoadOccasionsRequested());
  }

  void _checkIfDataLoaded() {
    // Marca como cargado cuando todas las listas tienen datos
    if (_categories.isNotEmpty &&
        _availableTags.isNotEmpty &&
        _colors.isNotEmpty &&
        _styles.isNotEmpty &&
        _occasions.isNotEmpty) {
      _isLoadingData = false;
    }
  }

  void _pickImage(ImageSource source) async {
    try {
      // Solicitar permisos según la fuente
      bool permissionGranted = false;
      
      if (source == ImageSource.camera) {
        // Solicitar permiso de cámara
        final cameraStatus = await Permission.camera.request();
        permissionGranted = cameraStatus.isGranted;
        
        if (!permissionGranted) {
          if (mounted) {
            _showPermissionDeniedDialog('cámara');
          }
          return;
        }
      } else {
        // Solicitar permiso de galería (diferente según la versión de Android)
        PermissionStatus status;
        if (Platform.isAndroid) {
          // Para Android 13+ (API 33+) usar photos, para versiones anteriores usar storage
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            status = await Permission.photos.request();
          } else {
            status = await Permission.storage.request();
          }
        } else {
          // Para iOS
          status = await Permission.photos.request();
        }
        
        permissionGranted = status.isGranted;
        
        if (!permissionGranted) {
          if (mounted) {
            _showPermissionDeniedDialog('galería');
          }
          return;
        }
      }

      final picked = await imgPicker.pickImage(
        //TODO: XFILE va fuera del dominio, por lo que es otro ds. Debería ser un String
        source: source,
        imageQuality: 80, // Comprimir al 80% para reducir tamaño
        maxWidth: 1200, // Límite de ancho
      );

      if (picked == null) return;

      setState(() {
        _selectedImagePath = picked.path;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  void _showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Permiso requerido',
          style: AppTypography.title.copyWith(color: AppColors.primary),
        ),
        content: Text(
          'Necesitamos acceso a tu $permissionType para continuar. '
          'Por favor, habilita el permiso en la configuración de la app.',
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(
              'Abrir Configuración',
              style: AppTypography.body.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: AppSpacing.paddingMedium,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Seleccionar imagen',
                style: AppTypography.title.copyWith(color: AppColors.primary),
              ),
              AppSpacing.verticalMedium,
              ListTile(
                leading: const Icon(Icons.camera_alt, size: 32),
                title: Text('Cámara', style: AppTypography.body),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, size: 32),
                title: Text('Galería', style: AppTypography.body),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              AppSpacing.verticalSmall,
            ],
          ),
        ),
      ),
    );
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

    if (_selectedColor == null ||
        _selectedStyle == null ||
        _selectedOccasion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor espera a que se carguen todos los datos'),
        ),
      );
      return;
    }

    context.read<WardrobeBloc>().add(
      AddGarmentRequested(
        imagePath: _selectedImagePath!,
        categoryId: _selectedCategory!.id,
        tagIds: _selectedTagIds.toList(),
        color: _selectedColor!,
        style: _selectedStyle!,
        occasion: _selectedOccasion!,
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
              _checkIfDataLoaded();
            });
          } else if (state is ColorsLoadedState) {
            setState(() {
              _colors = state.colors;
              if (_colors.isNotEmpty) {
                _selectedColor = _colors.first.name;
              }
              _checkIfDataLoaded();
            });
          } else if (state is StylesLoadedState) {
            setState(() {
              _styles = state.styles;
              if (_styles.isNotEmpty) {
                _selectedStyle = _styles.first.name;
              }
              _checkIfDataLoaded();
            });
          } else if (state is OccasionsLoadedState) {
            setState(() {
              _occasions = state.occasions;
              if (_occasions.isNotEmpty) {
                _selectedOccasion = _occasions.first.name;
              }
              _checkIfDataLoaded();
            });
          } else if (state is GarmentAddedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Prenda agregada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            // Recargar la lista de prendas antes de salir
            context.read<WardrobeBloc>().add(LoadGarmentsRequested());
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
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Selecciona una foto de tu prenda',
                        style: AppTypography.title.copyWith(
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Image Picker
                      GestureDetector(
                        onTap: _showImageSourceBottomSheet,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: _selectedImagePath == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_photo_alternate,
                                      size: 64,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Toca para seleccionar',
                                      style: AppTypography.body.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(_selectedImagePath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Category Selector
                      Text(
                        'Categoría',
                        style: AppTypography.subtitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Category>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        dropdownColor: AppColors.surface,
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name,
                              style: AppTypography.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
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
                      const SizedBox(height: 24),

                      // Color Selector
                      Text(
                        'Color',
                        style: AppTypography.subtitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedColor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        dropdownColor: AppColors.surface,
                        items: _colors.map((color) {
                          return DropdownMenuItem(
                            value: color.name,
                            child: Text(
                              color.name,
                              style: AppTypography.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
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
                      const SizedBox(height: 24),

                      // Style Selector
                      Text(
                        'Estilo',
                        style: AppTypography.subtitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStyle,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        dropdownColor: AppColors.surface,
                        items: _styles.map((style) {
                          return DropdownMenuItem(
                            value: style.name,
                            child: Text(
                              style.name,
                              style: AppTypography.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
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
                      const SizedBox(height: 24),

                      // Occasion Selector
                      Text(
                        'Ocasión',
                        style: AppTypography.subtitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedOccasion,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        dropdownColor: AppColors.surface,
                        items: _occasions.map((occasion) {
                          return DropdownMenuItem(
                            value: occasion.name,
                            child: Text(
                              occasion.name,
                              style: AppTypography.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
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
                      const SizedBox(height: 24),

                      // Tags Selector
                      Text(
                        'Tags (opcional)',
                        style: AppTypography.subtitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                                  final isSelected = _selectedTagIds.contains(
                                    tag.id,
                                  );
                                  return FilterChip(
                                    label: Text(tag.name),
                                    selected: isSelected,
                                    onSelected: (_) => _toggleTag(tag.id),
                                    backgroundColor: AppColors.surface,
                                    selectedColor: AppColors.primary,
                                    checkmarkColor: Colors.black,
                                    labelStyle: AppTypography.body.copyWith(
                                      color: isSelected
                                          ? Colors.black
                                          : AppColors.textPrimary,
                                    ),
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.border,
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 32),

                      // Add Button
                      BlocBuilder<WardrobeBloc, WardrobeState>(
                        builder: (context, state) {
                          final isLoading = state is WardrobeLoadingState;
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleAddGarment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: AppColors.primary
                                    .withOpacity(0.5),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.black,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Agregar Prenda',
                                      style: AppTypography.button.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
