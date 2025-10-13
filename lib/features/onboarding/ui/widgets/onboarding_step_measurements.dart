import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';

class OnboardingStepMeasurements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // En una implementación real, usarías controladores y sliders.
    // Por simplicidad, usamos valores fijos.
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cuéntanos sobre ti',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          const Placeholder(
            fallbackHeight: 100,
            child: Center(child: Text("Slider de Edad")),
          ),
          const SizedBox(height: 20),
          const Placeholder(
            fallbackHeight: 100,
            child: Center(child: Text("Slider de Altura")),
          ),
          const SizedBox(height: 20),
          const Placeholder(
            fallbackHeight: 100,
            child: Center(child: Text("Slider de Peso")),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Deberías obtener estos valores de los sliders
              context.read<OnboardingBloc>().add(
                MeasurementsUpdated(age: 28, height: 175.0, weight: 75.0),
              );
              context.read<OnboardingBloc>().add(NextPageRequested());
            },
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
