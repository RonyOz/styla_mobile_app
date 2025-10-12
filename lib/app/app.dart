import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/core.dart';
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

      theme: AppTheme.theme,

      initialRoute: session != null ? AppRoutes.home : AppRoutes.signup,

      routes: {...AppRouter.routes},
    );
  }
}
