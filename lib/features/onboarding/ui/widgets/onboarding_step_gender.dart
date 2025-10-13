import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';

class OnboardingStepGender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '¿Cuál es tu género?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Aquí irían tus widgets personalizados para seleccionar género
          ElevatedButton(
            onPressed: () =>
                context.read<OnboardingBloc>().add(GenderSelected("Femenino")),
            child: const Text('Femenino'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                context.read<OnboardingBloc>().add(GenderSelected("Masculino")),
            child: const Text('Masculino'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                context.read<OnboardingBloc>().add(GenderSelected("Otro")),
            child: const Text('Otro'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () =>
                context.read<OnboardingBloc>().add(NextPageRequested()),
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
