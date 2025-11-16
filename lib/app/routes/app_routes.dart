/// Definición de rutas de la aplicación
/// Contiene los nombres de las rutas como constantes
class AppRoutes {
  AppRoutes._();

  // Rutas principales
  static const String splash = '/';
  static const String home = '/home';

  // Ruta de bienvenida
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String onboarding3 = '/onboarding3';
  static const String welcome = '/welcome';

  //Rutas onboarding after signup
  static const onboardingSetup = '/start-setup';

  // Rutas de autenticación
  static const String login = '/login';
  static const String signup = '/signup';

  // Rutas de perfil
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String onboarding = '/onboarding';
  static const String addGarment = '/wardrobe/add-garment';
  static const String wardrobe = '/wardrobe';

  // Rutas de comunidad
  static const String userProfile = '/user-profile';
}
