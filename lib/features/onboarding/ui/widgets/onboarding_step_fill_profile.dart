import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/core/ui/design/app_colors.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_bloc.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_event.dart';
import 'package:styla_mobile_app/features/onboarding/ui/bloc/onboarding_state.dart';

class OnboardingStepFillProfile extends StatelessWidget {
  final String userEmail;
  final _fullNameController = TextEditingController(); 
  final _nicknameController = TextEditingController(); 
  final _phoneController = TextEditingController(); 

  final ValueNotifier<bool> _formValidNotifier = ValueNotifier(false);

  OnboardingStepFillProfile({super.key, required this.userEmail}) {
    void updateValidation() {
      final isValid = _fullNameController.text.isNotEmpty && _nicknameController.text.isNotEmpty;
      if (_formValidNotifier.value != isValid) {
        _formValidNotifier.value = isValid;
      }
    }

    _fullNameController.addListener(updateValidation);
    _nicknameController.addListener(updateValidation);
  }

  InputDecoration _inputDecoration({required String labelText, bool enabled = true}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: enabled ? Colors.black54 : Colors.grey.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      fillColor: enabled ? Colors.white : Colors.grey.shade200, 
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        
        return ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: state.currentPage > 0 
                    ? () => context.read<OnboardingBloc>().add(PreviousPageRequested())
                    : null,
                icon: Icon(Icons.arrow_back_ios, size: 16, color: state.currentPage > 0 ? AppColors.primary : AppColors.white.withOpacity(0.4)),
                label: Text('Back', style: TextStyle(fontSize: 16, color: state.currentPage > 0 ? AppColors.white : AppColors.white.withOpacity(0.4))),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Completa tu perfil',
              style: TextStyle(
                color: AppColors.textPrimary, 
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            const Text(
              'Transforma la experiencia de vestirte en algo sencillo y creativo, gracias a la inteligencia artificial y la comunidad de estilo',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 40),

            const Text('Nombre Completo', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)), 
            const SizedBox(height: 8),
            TextField(
              controller: _fullNameController,
              decoration: _inputDecoration(labelText: 'Nombre Completo'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),

            const Text('Usuario', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _nicknameController,
              decoration: _inputDecoration(labelText: 'Usuario'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),

            const Text('Correo', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)), 
            const SizedBox(height: 8),
            TextField(
              decoration: _inputDecoration(labelText: userEmail, enabled: false),
              enabled: false,
              style: TextStyle(color: Colors.grey.shade600),
              controller: TextEditingController(text: userEmail), 
            ),
            const SizedBox(height: 20),

            const Text('Número de Teléfono', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration(labelText: 'Número de Teléfono'),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 40),

            ValueListenableBuilder<bool>(
              valueListenable: _formValidNotifier,
              builder: (context, isReadyToProceed, child) {
                return SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isReadyToProceed 
                        ? () {
                            context.read<OnboardingBloc>().add(
                              ProfileInfoUpdated(
                                fullName: _fullNameController.text,
                                nickname: _nicknameController.text,
                                phoneNumber: _phoneController.text,
                              ),
                            );
                            context.read<OnboardingBloc>().add(SubmitOnboarding()); 
                        }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isReadyToProceed ? AppColors.primary : AppColors.textPrimary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      'EMPEZAR',
                      style: TextStyle(
                        fontSize: 18,
                        color: isReadyToProceed ? AppColors.black : AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}