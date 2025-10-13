import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/events/signup_event.dart';
import '../bloc/states/signup_state.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignupContent();
  }
}

class _SignupContent extends StatefulWidget {
  const _SignupContent();

  @override
  State<_SignupContent> createState() => _SignupContentState();
}

class _SignupContentState extends State<_SignupContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      context.read<SignupBloc>().add(
            SignupRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        centerTitle: true,
      ),
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLarge,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 48),
                    _buildForm(state),
                    const SizedBox(height: 32),
                    _buildSignupButton(state),
                    AppSpacing.verticalLarge,
                    _buildLoginLink(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Icon(
          Icons.person_add_outlined,
          size: 80,
          color: AppColors.primary,
        ),
        AppSpacing.verticalMedium,
        Text(
          'Bienvenido',
          style: AppTypography.title,
        ),
        AppSpacing.verticalSmall,
        Text(
          'Crea tu cuenta para comenzar',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(SignupState state) {
    return Column(
      children: [
        AppTextField(
          label: 'Email',
          hint: 'ejemplo@correo.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),
        AppSpacing.verticalMedium,
        AppTextField(
          label: 'Contraseña',
          hint: 'Mínimo 6 caracteres',
          controller: _passwordController,
          obscureText: _obscurePassword,
          validator: _validatePassword,
        ),
        AppSpacing.verticalMedium,
        AppTextField(
          label: 'Confirmar contraseña',
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          validator: _validateConfirmPassword,
        ),
      ],
    );
  }

  Widget _buildSignupButton(SignupState state) {
    final isLoading = state is SignupLoadingState;

    return AppButton.primary(
      text: 'Crear cuenta',
      onPressed: _handleSignup,
      isLoading: isLoading,
    );
  }

  Widget _buildLoginLink(SignupState state) {
    final isLoading = state is SignupLoadingState;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿Ya tienes cuenta?'),
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Iniciar sesión'),
        ),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, SignupState state) {
    if (state is SignupSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta creada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (state is SignupErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}
