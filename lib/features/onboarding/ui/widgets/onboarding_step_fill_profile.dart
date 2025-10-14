import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';

class OnboardingStepFillProfile extends StatelessWidget {
  final String userEmail;
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _agecontroller = TextEditingController();

  OnboardingStepFillProfile({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Completa tu perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre Completo',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: 'Usuario',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: userEmail,
              enabled: false,
              border: const OutlineInputBorder(),
              fillColor: Colors.grey,
              filled: true,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Número de Teléfono',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          const SizedBox(height: 20),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              context.read<OnboardingBloc>().add(
                ProfileInfoUpdated(
                  fullName: _fullNameController.text,
                  nickname: _nicknameController.text,
                  phoneNumber: _phoneController.text,
                  age: int.tryParse(_agecontroller.text) ?? 0,
                ),
              );
              context.read<OnboardingBloc>().add(SubmitOnboarding());
            },
            child: const Text('EMPEZAR'),
          ),
        ],
      ),
    );
  }
}
