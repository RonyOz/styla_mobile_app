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
      backgroundColor: AppColors.background,
      appBar: const AuthAppBar(),
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
                    AppSpacing.verticalLarge,
                    _buildSocialLogin(),
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
         // Title
        Text(
          'Crea tu cuenta',
          style: AppTypography.title.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        Text(
          'En Styla consigue tu mejor estilo',
          style: AppTypography.subtitle.copyWith(color: AppColors.textPrimary)
        ),
        AppSpacing.verticalSmall,
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
      Text(
        '¿Ya tienes cuenta? ', 
        style: AppTypography.body.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      TextButton(
        onPressed: isLoading ? null : () => Navigator.pushReplacementNamed(context, AppRoutes.login),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Iniciar sesión',
          style: AppTypography.body.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
  return Column(
    children: [
      Text(
        'Resgistrate con', 
        style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
        textAlign: TextAlign.center,
      ),
      AppSpacing.verticalMedium,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.g_mobiledata,
              size: 32,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.horizontalMedium,
          // Botón Facebook
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.facebook, color: Colors.blue),
            ),
          ],
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
