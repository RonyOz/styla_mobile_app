import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';

class _StyleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isSelected ? AppColors.primary : Colors.white;
    final Color circleColor = isSelected
        ? AppColors.primary
        : Colors.white.withOpacity(0.15);
    final Color borderColor = isSelected
        ? AppColors.primary
        : Colors.white.withOpacity(0.25);
    final Color iconColor = isSelected
        ? AppColors.black
        : Colors.white.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: 56,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected
                ? AppColors.primary.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
            side: BorderSide(color: borderColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 14, color: iconColor)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingStepStyle extends StatefulWidget {
  const OnboardingStepStyle({super.key});

  @override
  State<OnboardingStepStyle> createState() => _OnboardingStepStyleState();
}

class _OnboardingStepStyleState extends State<OnboardingStepStyle> {
  @override
  void initState() {
    super.initState();
    // Cargar estilos desde la base de datos
    context.read<OnboardingBloc>().add(LoadStylesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final String selectedStyle = state.preferences.name;
        final styles = state.availableStyles.map((s) => s.name).toList();

        // Si el estilo seleccionado no está en la lista, limpiar la selección
        final validSelectedStyle =
            selectedStyle != null && styles.contains(selectedStyle)
            ? selectedStyle
            : null;

        final isReadyToProceed =
            validSelectedStyle != null && validSelectedStyle.isNotEmpty;

        // Mostrar loading mientras se cargan los estilos
        if (styles.isEmpty) {
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
              '¿Cómo describes tu estilo?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            const Text(
              'Descubre un asistente de estilo que se adapta a ti, a tu armario y a la vida que quieres proyectar',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 40),

            ...styles.map((style) {
              return _StyleOption(
                label: style,
                isSelected: style == validSelectedStyle,
                onTap: () {
                  context.read<OnboardingBloc>().add(StyleSelected(style));
                },
              );
            }),

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
                      ? Colors.yellow
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
