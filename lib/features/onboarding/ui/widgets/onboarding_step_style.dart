import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';

class OnboardingStepStyle extends StatelessWidget {
  final styles = ["Básico", "Elegante", "Street Wear", "Boho Chic", "Otros"];

  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.all(24.0),
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           const Text('¿Cómo describes tu estilo?', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          ...styles.map((style) => ElevatedButton(
            onPressed: () {
              context.read<OnboardingBloc>().add(StyleSelected(style));
              context.read<OnboardingBloc>().add(NextPageRequested());
            },
            child: Text(style),
          )),
          const Spacer(),
        ],
      ),
    );
  }
}