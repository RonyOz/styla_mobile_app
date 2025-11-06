import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/ui/design/app_colors.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';

class _ColorButton extends StatelessWidget {
  final String color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorButton({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isSelected ? AppColors.black : AppColors.white;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox.expand(
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? AppColors.primary
                : AppColors.textPrimary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            color,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _ImageSelector extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _ImageSelector({
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(imagePath, fit: BoxFit.cover, height: 200),
        ),
      ),
    );
  }
}

class OnboardingStepAdditionalInfo extends StatefulWidget {
  @override
  State<OnboardingStepAdditionalInfo> createState() =>
      _OnboardingStepAdditionalInfoState();
}

class _OnboardingStepAdditionalInfoState
    extends State<OnboardingStepAdditionalInfo> {
  final String imagePath1 = 'assets/images/outfits/outfit1.png';
  final String imagePath2 = 'assets/images/outfits/outfit2.png';

  static const imagePref1 = 'URL_IMAGEN_1';
  static const imagePref2 = 'URL_IMAGEN_2';

  @override
  void initState() {
    super.initState();
    // Cargar colores desde la base de datos
    context.read<OnboardingBloc>().add(LoadColorsRequested());
  }

  String _getSelectedColor(String? name) {
    if (name == null || name.isEmpty) return '';
    return name.split(' ')[0];
  }

  String _getSelectedImage(String? name) {
    if (name == null || name.isEmpty) return '';
    final parts = name.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final prefsName = state.preferences.name;
        final colors = state.availableColors.map((c) => c.name).toList();

        final rawSelectedColor = _getSelectedColor(prefsName);
        final selectedImage = _getSelectedImage(prefsName);

        // Validar que el color seleccionado existe en la lista
        final selectedColor =
            rawSelectedColor.isNotEmpty && colors.contains(rawSelectedColor)
            ? rawSelectedColor
            : '';

        final isReadyToProceed =
            selectedColor.isNotEmpty && selectedImage.isNotEmpty;

        // Mostrar loading mientras se cargan los colores
        if (colors.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: state.currentPage > 0
                    ? () => context.read<OnboardingBloc>().add(
                        PreviousPageRequested(),
                      )
                    : null,
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: state.currentPage > 0
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                ),
                label: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 16,
                    color: state.currentPage > 0
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Info adicional',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            const Text(
              'Reimagina tu closet como un espacio de creatividad, no de rutina. Styla te muestra cómo lograrlo sin complicaciones',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 40),

            const Text(
              '¿Color de ropa preferido?',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                return _ColorButton(
                  color: color,
                  isSelected: selectedColor == color,
                  onTap: () {
                    final newImage = selectedImage.isNotEmpty
                        ? selectedImage
                        : imagePref1;
                    context.read<OnboardingBloc>().add(
                      AdditionalInfoUpdated(
                        color: color,
                        imagePreference: newImage,
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 40),

            const Text(
              '¿Cuál te gusta más?',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _ImageSelector(
                    imagePath: imagePath1,
                    isSelected: selectedImage == imagePref1,
                    onTap: () {
                      final newColor = selectedColor.isNotEmpty
                          ? selectedColor
                          : colors[0];
                      context.read<OnboardingBloc>().add(
                        AdditionalInfoUpdated(
                          color: newColor,
                          imagePreference: imagePref1,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ImageSelector(
                    imagePath: imagePath2,
                    isSelected: selectedImage == imagePref2,
                    onTap: () {
                      final newColor = selectedColor.isNotEmpty
                          ? selectedColor
                          : colors[0];
                      context.read<OnboardingBloc>().add(
                        AdditionalInfoUpdated(
                          color: newColor,
                          imagePreference: imagePref2,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isReadyToProceed
                    ? () => context.read<OnboardingBloc>().add(
                        NextPageRequested(),
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isReadyToProceed
                      ? AppColors.primary
                      : Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Siguiente',
                      style: TextStyle(
                        fontSize: 18,
                        color: isReadyToProceed ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isReadyToProceed ? Colors.black : Colors.white54,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
