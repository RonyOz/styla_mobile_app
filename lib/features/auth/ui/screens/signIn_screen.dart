import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/app/routes/app_routes.dart';
import 'package:styla_mobile_app/core/core.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/events/signin_event.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/signin_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/states/signin_state.dart';
import 'package:styla_mobile_app/features/auth/ui/widgets/auth_app_bar.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() {
    return SigninScreenState();
  }
}

class SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget content() => Padding(
    padding: AppSpacing.paddingLarge,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Text(
          'Inicia Sesión',
          style: AppTypography.title.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalSmall,
        // Subtitle
        Text(
          '¡Qué bueno verte de nuevo!',
          style: AppTypography.subtitle,
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalLarge,
        // Email input
        AppTextField(
          controller: emailController,
          label: 'Username or email',
        ),
        AppSpacing.verticalMedium,
        // Password input
        AppTextField(
          controller: passwordController,
          label: 'Password',
          obscureText: true,
        ),
        AppSpacing.verticalLarge,
        // Submit button
        submitButton(),
        AppSpacing.verticalSmall,
        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: AppTypography.caption,
            ),
          ),
        ),
        const Spacer(),
        // Social login
        Text(
          'O inicia con',
          style: AppTypography.caption,
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
              child: Icon(Icons.g_mobiledata, size: 32, color: AppColors.textPrimary),
            ),
            AppSpacing.horizontalMedium,
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
        AppSpacing.verticalLarge,
        // Sign up link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No tienes cuenta? ',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signup),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Crear cuenta',
                style: AppTypography.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.verticalLarge,
      ],
    ),
  );

  Widget submitButton() => BlocBuilder<SigninBloc, SignInState>(
    builder: (context, state) {
      final isLoading = state is SignInLoadingState;
      return AppButton.primary(
        text: 'Continuar',
        onPressed: isLoading
            ? null
            : () {
                context.read<SigninBloc>().add(
                  SignInRequested(
                    email: emailController.text,
                    password: passwordController.text,
                  ),
                );
              },
        isLoading: isLoading,
        icon: Icons.arrow_forward,
      );
    },
  );

  Widget dynamicContent() => BlocBuilder<SigninBloc, SignInState>(
    builder: (context, state) {
      if (state is SignInIdleState) {
        return content();
      } else if (state is SignInLoadingState) {
        return content();
      } else if (state is SignInErrorState) {
        return Column(
          children: [
            Expanded(child: content()),
            Container(
              padding: AppSpacing.paddingMedium,
              color: AppColors.error,
              child: Text(
                state.message,
                style: AppTypography.body.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      } else if (state is SignInSuccessState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/home');
        });
        return const SizedBox.shrink();
      } else {
        return const SizedBox.shrink();
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AuthAppBar(),
      body: SafeArea(
        child: dynamicContent(),
      ),
    );
  }
}