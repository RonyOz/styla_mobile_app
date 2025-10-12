import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';

class OnboardingStepAdditionalInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           const Text('Información adicional', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          const Text('¿Color de ropa preferido?', style: TextStyle(color: Colors.white70, fontSize: 18)),
          const Placeholder(fallbackHeight: 100, child: Center(child: Text("Selector de Colores"))),
           const SizedBox(height: 20),
           const Text('¿Cuál te gusta más?', style: TextStyle(color: Colors.white70, fontSize: 18)),
           // Aquí irían las imágenes seleccionables
          const Row(children: [
            Expanded(child: Placeholder(fallbackHeight: 200, child: Center(child: Text("Imagen 1")))),
            SizedBox(width: 16),
            Expanded(child: Placeholder(fallbackHeight: 200, child: Center(child: Text("Imagen 2")))),
          ]),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              context.read<OnboardingBloc>().add(AdditionalInfoUpdated(color: "Negro", imagePreference: "URL_IMAGEN_1"));
              context.read<OnboardingBloc>().add(NextPageRequested());
            },
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}