import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/events/signup_event.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/signup_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/states/signup_state.dart';
import 'package:styla_mobile_app/features/auth/ui/widgets/auth_app_bar.dart';

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
      // navigate to signup
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta'), centerTitle: true),
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
        Icon(Icons.person_add_outlined, size: 80, color: AppColors.primary),
        AppSpacing.verticalMedium,
        Text(
          'Bienvenido',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppSpacing.verticalSmall,
        Text(
          'Crea tu cuenta para comenzar',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        AppSpacing.verticalMedium,
        AppTextField(
          label: 'Confirmar contraseña',
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          validator: _validateConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSignupButton(SignupState state) {
    final isLoading = state is SignupLoadingState;

    return ElevatedButton(
      onPressed: isLoading ? null : _handleSignup,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text(
              'Crear cuenta',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _buildLoginLink(SignupState state) {
    final isLoading = state is SignupLoadingState;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿Ya tienes cuenta?'),
        TextButton(
          onPressed: isLoading
              ? null
              : () => Navigator.pushReplacementNamed(context, AppRoutes.login),
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
      // Opción B (recomendada si NO quieres que vuelvan con “back”):
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.onboardingSetup,
        (route) => false,
      );
    } else if (state is SignupErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
