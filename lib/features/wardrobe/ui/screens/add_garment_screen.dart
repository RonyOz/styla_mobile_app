import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';

class AddGarmentScreen extends StatefulWidget {
  const AddGarmentScreen({super.key});

  @override
  State<AddGarmentScreen> createState() => _AddGarmentScreenState();
}

class _AddGarmentScreenState extends State<AddGarmentScreen> {
  String? _selectedImagePath;
  String _selectedCategory = 'camisa';

  final List<String> _categories = [
    'camisa',
    'pantalón',
    'zapatos',
    'accesorios',
  ];

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

    context.read<WardrobeBloc>().add(
          AddGarmentRequested(
            imagePath: _selectedImagePath!,
            category: _selectedCategory,
          ),
        );
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
          if (state is GarmentAddedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Prenda agregada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is WardrobeErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
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
                DropdownButtonFormField<String>(
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
                        category,
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
