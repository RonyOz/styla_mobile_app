import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';

class _GenderOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String genderValue;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.icon,
    required this.label,
    required this.genderValue,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Definición de colores
    final Color iconColor = isSelected ? AppColors.black : AppColors.textPrimary;
    final Color circleColor = isSelected ? AppColors.primary : AppColors.textPrimary.withOpacity(0.1);
    final Color borderColor = isSelected ? AppColors.primary : AppColors.textPrimary.withOpacity(0.4);

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Icon(
              icon,
              size: 40,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class OnboardingStepGender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final String? selectedGender = state.data.gender; 
        final bool isGenderSelected = selectedGender != null && selectedGender.isNotEmpty;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => context.read<OnboardingBloc>().add(PreviousPageRequested()),
                  icon: const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.textPrimary),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  ),
                ),
              ),
              const Spacer(),

              // Título
              const Text(
                '¿Cuál es tu género?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 60),
              
              //Opciones de Género
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Femenino
                    _GenderOption(
                      icon: Icons.female,
                      label: 'Femenino',
                      genderValue: 'Femenino',
                      isSelected: selectedGender == 'Femenino', 
                      onTap: () => context.read<OnboardingBloc>().add(GenderSelected("Femenino")),
                    ),
                    const SizedBox(height: 30),
                    
                    //Masculino
                    _GenderOption(
                      icon: Icons.male,
                      label: 'Masculino',
                      genderValue: 'Masculino',
                      isSelected: selectedGender == 'Masculino',
                      onTap: () => context.read<OnboardingBloc>().add(GenderSelected("Masculino")),
                    ),
                    const SizedBox(height: 30),
                    
                    //Otros
                    _GenderOption(
                      icon: Icons.add,
                      label: 'Otros',
                      genderValue: 'Otro',
                      isSelected: selectedGender == 'Otro',
                      onTap: () => context.read<OnboardingBloc>().add(GenderSelected("Otro")),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: isGenderSelected 
                      ? () => context.read<OnboardingBloc>().add(NextPageRequested())
                      : null, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: isGenderSelected 
                        ? const BorderSide(color: AppColors.secondary, width: 2) 
                        : BorderSide.none,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Siguiente',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, size: 16, color: isGenderSelected ? AppColors.secondary : AppColors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}