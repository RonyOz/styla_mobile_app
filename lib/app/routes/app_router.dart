import 'package:flutter/material.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/signin_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/screens/signIn_screen.dart';
import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';
import 'package:styla_mobile_app/features/dress/ui/bloc/dress_bloc.dart';
import 'package:styla_mobile_app/features/dress/ui/screens/dress_screen.dart';
import 'package:styla_mobile_app/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/app/pages/onboarding_setup_page.dart';
import 'package:styla_mobile_app/app/pages/welcome/onboarding_page_1.dart';
import 'package:styla_mobile_app/app/pages/welcome/onboarding_page_2.dart';
import 'package:styla_mobile_app/app/pages/welcome/onboarding_page_3.dart';

import 'package:styla_mobile_app/features/profile/ui/bloc/profile_bloc.dart';
import 'package:styla_mobile_app/features/profile/ui/screens/profile_screen.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/wardrobe_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/add_garment_screen.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/screens/wardrobe_screen.dart';
import 'package:styla_mobile_app/features/community/ui/screens/user_profile_screen.dart';
import 'package:styla_mobile_app/features/community/ui/bloc/community_bloc.dart';

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
      AppRoutes.onboarding: (context) => OnboardingScreen(),

      AppRoutes.login: (context) => BlocProvider(
        create: (_) => SigninBloc(),
        child: const SigninScreen(),
      ),

      AppRoutes.home: (context) => const HomePage(),

      AppRoutes.profile: (context) => BlocProvider(
        create: (_) => ProfileBloc(),
        child: const ProfileScreen(),
      ),

      AppRoutes.wardrobe: (context) => BlocProvider(
        create: (_) => WardrobeBloc(),
        child: const WardrobeScreen(),
      ),

      AppRoutes.addGarment: (context) => BlocProvider(
        create: (_) => WardrobeBloc(),
        child: const AddGarmentScreen(),
      ),

      AppRoutes.dressUp: (context) => BlocProvider(
        create: (_) => DressBloc(),
        child: const VestirseScreen(),
      ),
    };
  }

  /// Genera rutas dinámicas para navegación avanzada
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.userProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => CommunityBloc(communityRepository: CommunityRepositoryImpl(),),
              child: UserProfileScreen(
                userId: args['userId'] as String,
                nickname: args['nickname'] as String?,
                photo: args['photo'] as String?,
              ),
            ),
          );
        }
        return null;
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
