import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/signin_bloc.dart';
import 'package:styla_mobile_app/features/auth/ui/screens/signIn_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'Styla Mobile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set initial route based on session
      initialRoute: session != null ? AppRoutes.home : AppRoutes.login,
      // Add login route to the main router
      routes: {
        ...AppRouter.routes,
        AppRoutes.login: (_) => BlocProvider(
          create: (_) => SigninBloc(),
          child: const SigninScreen(),
        ),
      },
    );
  }
}
