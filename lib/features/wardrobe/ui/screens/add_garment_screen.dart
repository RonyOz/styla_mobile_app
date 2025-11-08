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
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/image_picker_section.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/custom_dropdown_field.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/tag_selector_section.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/widgets/image_source_bottom_sheet.dart';

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
    ImageSourceBottomSheet.show(
      context,
      onCameraTap: () => _pickImage(ImageSource.camera),
      onGalleryTap: () => _pickImage(ImageSource.gallery),
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
        title: Text(
          'Agregar Prenda',
          style: AppTypography.subtitle.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
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
                      ImagePickerSection(
                        selectedImagePath: _selectedImagePath,
                        onTap: _showImageSourceBottomSheet,
                      ),
                      const SizedBox(height: 24),

                      // Category Selector
                      CustomDropdownField<Category>(
                        label: 'Categoría',
                        value: _selectedCategory,
                        items: _categories,
                        itemLabel: (category) => category.name,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCategory = value);
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Color Selector
                      CustomDropdownField<String>(
                        label: 'Color',
                        value: _selectedColor,
                        items: _colors.map((c) => c.name).toList(),
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedColor = value);
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Style Selector
                      CustomDropdownField<String>(
                        label: 'Estilo',
                        value: _selectedStyle,
                        items: _styles.map((s) => s.name).toList(),
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedStyle = value);
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Occasion Selector
                      CustomDropdownField<String>(
                        label: 'Ocasión',
                        value: _selectedOccasion,
                        items: _occasions.map((o) => o.name).toList(),
                        itemLabel: (item) => item,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedOccasion = value);
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Tags Selector
                      TagSelectorSection(
                        availableTags: _availableTags,
                        selectedTagIds: _selectedTagIds,
                        onTagToggled: _toggleTag,
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
