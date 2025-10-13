import 'package:flutter/material.dart';
import 'package:styla_mobile_app/app/app.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/signin_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/screens/signin_screen.dart';
import 'package:styla_mobile_app/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/app/pages/onboarding_setup_page.dart';
import 'package:styla_mobile_app/app/pages/welcome/onboarding_page_1.dart';
import 'package:styla_mobile_app/app/pages/welcome/onboarding_page_2.dart';
import 'package:styla_mobile_app/app/pages/welcome/onboarding_page_3.dart';

import 'package:styla_mobile_app/features/auth/ui/bloc/signin_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/signup_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/screens/signin_screen.dart';
import 'package:styla_mobile_app/features/auth/ui/screens/signup_screen.dart';

import 'package:styla_mobile_app/features/profile/ui/bloc/profile_bloc.dart';
import 'package:styla_mobile_app/features/profile/ui/screens/profile_screen.dart';

import 'package:styla_mobile_app/features/onboarding/ui/screens/onboarding_screen.dart';
import '../pages/home_page.dart';
import '../pages/splash_page.dart';
import '../pages/welcome/welcome_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.splash: (context) => const SplashPage(),
      AppRoutes.onboarding1: (context) => const OnboardingPage1(),
      AppRoutes.onboarding2: (context) => const OnboardingPage2(),
      AppRoutes.onboarding3: (context) => const OnboardingPage3(),
      AppRoutes.welcome: (context) => const WelcomePage(),
      AppRoutes.onboardingSetup: (_) => const OnboardingSetupPage(),
      AppRoutes.home: (context) => const HomePage(),
      AppRoutes.onboarding: (context) => OnboardingScreen(),
      AppRoutes.profile: (context) => BlocProvider(
        create: (_) => ProfileBloc(),
        child: const ProfileScreen(),
      ),
      AppRoutes.login: (context) => BlocProvider(
        create: (_) => SigninBloc(),
        child: const SigninScreen(),
      ),
      // TODO: Agregar rutas de features (auth, profile, etc)
    };
  }

  /// Genera rutas dinámicas para navegación avanzada
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return null;
    }
  }

  /// Ruta de error cuando no se encuentra una ruta
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) =>
          const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
    );
  }
}
